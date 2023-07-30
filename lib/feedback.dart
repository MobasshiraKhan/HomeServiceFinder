import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Components/custombutton.dart';

class FeedbackPage extends StatefulWidget {
  final orders;
  const FeedbackPage({Key? key, required this.orders}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final ref = FirebaseFirestore.instance.collection('feedbacks');

  late List<String> sellers = [];
  String selected = '';
  TextEditingController feedback = TextEditingController();
  final auth = FirebaseAuth.instance.currentUser;

  String getSellerId(name) {
    for (int i = 0; i < widget.orders.length; i++) {
      if (widget.orders[i]['seller_name'] == selected)
        return widget.orders[i]['seller_id'];
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.orders.length; i++) {
      sellers.add(widget.orders[i]['seller_name']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text('Select your seller'),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: DropdownButton<String>(
                  items: sellers.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selected = value!;
                    });
                  },
                  underline: Container(),
                ),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Submit Your Feedback',
                  border: OutlineInputBorder(),
                ),
              ),
              CustomButton(
                txt: 'Submit',
                action: () {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  ref.add({
                    'feedback': feedback.text,
                    'feedback_id': id,
                    'username': '${auth?.uid}',
                    'seller_name': selected,
                    'seller_id': getSellerId(selected),
                    'user_id': '${auth?.displayName}',
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Feedback Submitted')));
                    setState(() {
                      feedback.text = '';
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
