import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Components/custombutton.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final ref = FirebaseFirestore.instance.collection('reports');
  TextEditingController report = TextEditingController();
  final auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Submit Your Report',
                  border: OutlineInputBorder(),
                ),
              ),
              CustomButton(
                txt: 'Submit',
                action: () {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  ref.add({
                    'report': report.text,
                    'report_id': id,
                    'username': '${auth?.uid}',
                    'user_id': '${auth?.displayName}',
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Report Submitted')));
                    setState(() {
                      report.text = '';
                    });
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Something error occurred')));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
