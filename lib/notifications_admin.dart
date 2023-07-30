import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({Key? key}) : super(key: key);

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        titleSpacing: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ref.collection('notice').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, i) {
                DocumentSnapshot doc = snapshot.data!.docs[i];
                return ListTile(
                  title: Text(doc['title']),
                  subtitle: Text(doc['desc']),
                  trailing: Icon(Icons.add_alert_sharp),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(height: 0);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}