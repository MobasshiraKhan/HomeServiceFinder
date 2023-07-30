import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> with TickerProviderStateMixin {
  late TabController _tabController;
  int index = 0;
  List<String> tabs = [
    "All",
    "Requested",
    // "Completed",
    "Processing",
    // "Paid",
    "Cancelled"
  ];
  final uref = FirebaseFirestore.instance.collection('users');
  final ref = FirebaseFirestore.instance.collection('orders');
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('My Bookings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              physics: ClampingScrollPhysics(),
              isScrollable: true,
              controller: _tabController,
              indicatorColor: Colors.green,
              padding: EdgeInsets.all(10),
              tabs: tabs
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
              indicator: RectangularIndicator(
                color: Colors.blue,
                bottomLeftRadius: 100,
                bottomRightRadius: 100,
                topLeftRadius: 100,
                topRightRadius: 100,
              ),
              onTap: (i) {
                setState(() {
                  index = i;
                });
              },
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: index != 0
                  ? ref
                      .where('customer_id',
                          isEqualTo: '${auth.currentUser?.uid}')
                      .where('state', isEqualTo: tabs[index])
                      .snapshots()
                  : ref
                      .where('customer_id',
                          isEqualTo: '${auth.currentUser?.uid}')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, i) {
                        DocumentSnapshot doc = snapshot.data!.docs[i];
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            // leading: Image.asset(
                            //     'assets/images/' + providers[i]['image']),
                            title: Text('Seller Name: ${doc['seller_name']}'),
                            subtitle: Text('Location: ${doc['location']}'),
                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  if (doc['state'] == 'Requested')
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: Text('Are you sure?'),
                                                  content: Text(
                                                      'Do you want to cancel this order?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('No')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            await ref
                                                                .doc(doc[
                                                                    'order_id'])
                                                                .update({
                                                              'state':
                                                                  "Cancelled",
                                                            });
                                                            await uref
                                                                .doc(
                                                                    "${doc['customer_id']}")
                                                                .collection(
                                                                    'notifications')
                                                                .add({
                                                              'title': 'Order',
                                                              'details':
                                                                  'Your order has been cancelled',
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('This order has been cancelled')));
                                                          } catch (e) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('${e.toString()}')));
                                                          }
                                                        },
                                                        child: Text('Yes')),
                                                  ],
                                                ));
                                      },
                                      child: SvgPicture.asset(
                                          'assets/svg/reject.svg',
                                          width: 40),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
