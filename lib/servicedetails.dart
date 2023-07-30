import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kormomukhi/chatscreen.dart';
import 'Values/values.dart';

class ServiceDetails extends StatefulWidget {
  final String title, details;
  const ServiceDetails({Key? key, required this.title, required this.details})
      : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final location = TextEditingController();
  String title = '';
  String details = '';
  final ref = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String pay = 'Online';
  String online = 'Bkash';

  @override
  void initState() {
    super.initState();
    title = widget.title;
    details = widget.details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              space,
              Text(
                "50 BDT",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              space,
              Text(
                "$details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              space,
              Text(
                'Provides Nearby',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: ref
                    .collection('users')
                    .where('registerAsSellerRole', isEqualTo: title)
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
                            title: Text(doc['name']),
                            leading: doc['image'] == ''
                                ? Flexible(
                                    child: Image.asset(
                                      'assets/images/user.png',
                                      width: 40,
                                    ),
                                  )
                                : Flexible(
                                    child: Image.network(
                                      doc['image'],
                                      width: 40,
                                    ),
                                  ),
                            subtitle: Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: 5.0,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemSize: 15,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                Text('10'),
                              ],
                            ),
                            trailing: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (_) => Column(
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (_) => AlertDialog(
                                                                  title: Text(
                                                                      'Set your location'),
                                                                  content: StatefulBuilder(builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        TextField(
                                                                          keyboardType:
                                                                              TextInputType.multiline,
                                                                          maxLines:
                                                                              5,
                                                                          minLines:
                                                                              5,
                                                                          controller:
                                                                              location,
                                                                        ),
                                                                        Text(
                                                                            'Payment via:'),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    pay = 'Online';
                                                                                    online = 'Bkash';
                                                                                  });
                                                                                },
                                                                                child: Text('Online'),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 2),
                                                                            Expanded(
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    pay = 'Cash';
                                                                                    online = 'No';
                                                                                  });
                                                                                },
                                                                                child: Text('Cash'),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                            'Selected: $pay'),
                                                                        if (online !=
                                                                            'No')
                                                                          Text(
                                                                              'Select Online Method:'),
                                                                        if (online !=
                                                                            'No')
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      online = 'Bkash';
                                                                                    });
                                                                                  },
                                                                                  child: Text('Bkash'),
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 2),
                                                                              Expanded(
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      online = 'Nagad';
                                                                                    });
                                                                                  },
                                                                                  child: Text('Nagad'),
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 2),
                                                                              Expanded(
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      online = 'Rocket';
                                                                                    });
                                                                                  },
                                                                                  child: Text('Rocket'),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        if (online !=
                                                                            'No')
                                                                          Text(
                                                                              'Selected: $online'),
                                                                      ],
                                                                    );
                                                                  }),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            'Cancel')),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        String id = DateTime.now()
                                                                            .microsecondsSinceEpoch
                                                                            .toString();
                                                                        ref.collection('orders').doc("${id}").set({
                                                                          'order_id':
                                                                              id,
                                                                          'customer_id': auth
                                                                              .currentUser
                                                                              ?.uid,
                                                                          'customer_name': auth
                                                                              .currentUser
                                                                              ?.displayName,
                                                                          'seller_name':
                                                                              doc['name'],
                                                                          'seller_id':
                                                                              doc['uid'],
                                                                          'location':
                                                                              location.text,
                                                                          'state':
                                                                              'Requested',
                                                                          'pay':
                                                                              pay,
                                                                          'online':
                                                                              online,
                                                                          'via':
                                                                              'NOGPS'
                                                                        }).then(
                                                                            (value) {
                                                                          Navigator.pop(
                                                                              context);
                                                                          ref
                                                                              .collection('users')
                                                                              .doc("${auth.currentUser?.uid}")
                                                                              .collection('notifications')
                                                                              .add({
                                                                            'title':
                                                                                'Order',
                                                                            'details':
                                                                                '${doc['name']} is coming soon. Wait for the response',
                                                                          }).then((value) {
                                                                            ref.collection('users').doc('${doc["uid"]}').collection('notifications').add({
                                                                              'title': 'Order',
                                                                              'details': '${auth?.currentUser?.displayName} is calling you for work. He will pay via $pay',
                                                                            });
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (_) => AlertDialog(
                                                                                      title: Text('Order'),
                                                                                      content: Text('${doc['name']} is coming soon. Wait for the response'),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Text('OK')),
                                                                                      ],
                                                                                    ));
                                                                          });
                                                                        }).onError((error,
                                                                            stackTrace) {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(content: Text('${error.toString()}')));
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                          'Confirm'),
                                                                    ),
                                                                  ],
                                                                ));
                                                  },
                                                  child: Text('Hire')),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ChatScreen(
                                                        worker: doc['name'],
                                                        workerId: doc['uid'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text('Message'),
                                              ),
                                            ],
                                          ));
                                },
                                child: Text('Select')),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
