import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kormomukhi/feedback.dart';
import 'package:kormomukhi/login.dart';
import 'package:kormomukhi/report.dart';
import 'package:kormomukhi/seller_request.dart';

import 'Models/User.dart';
import 'Profile.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 250,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage('${auth.currentUser?.photoURL}'),
              ),
              Container(
                margin: EdgeInsets.only(top: 130),
                child: Text(
                  '${auth.currentUser?.displayName}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            ListTile(
              leading: FaIcon(FontAwesomeIcons.person),
              title: Text('Profile'),
              trailing: FaIcon(FontAwesomeIcons.arrowRight),
              onTap: () async {
                try {
                  FirebaseAuth user = FirebaseAuth.instance;
                  QuerySnapshot<Map<String, dynamic>> snapshot =
                      await FirebaseFirestore.instance
                          .collection("users")
                          .where('uid', isEqualTo: user.currentUser?.uid)
                          .get();
                  final userx = snapshot.docs
                      .map((docSnapshot) =>
                          CurrentUser.fromDocumentSnapshot(docSnapshot))
                      .toList();
                  final userxx = userx[0];

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Profile(
                                name: userxx.name,
                                email: userxx.email,
                                phone: userxx.phone,
                                nid: userxx.nid,
                              )));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('${e.toString()}')));
                }
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            //   trailing: FaIcon(FontAwesomeIcons.arrowRight),
            // ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Report'),
              trailing: FaIcon(FontAwesomeIcons.arrowRight),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Report()));
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              trailing: FaIcon(FontAwesomeIcons.arrowRight),
              onTap: () async {
                final allorders = await FirebaseFirestore.instance
                    .collection('orders')
                    .where('customer_id', isEqualTo: '${auth.currentUser?.uid}')
                    .get();
                final orders = allorders.docs.map((doc) => doc.data()).toList();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => FeedbackPage(orders: orders)));
              },
            ),
            ListTile(
              title: Text('Logout'),
              trailing: FaIcon(FontAwesomeIcons.arrowRight),
              leading: Icon(Icons.logout),
              onTap: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LogIn()));
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Something went wrong')));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
