import 'package:flutter/material.dart';

class Agree extends StatefulWidget {
  const Agree({Key? key}) : super(key: key);

  @override
  State<Agree> createState() => _AgreeState();
}

class _AgreeState extends State<Agree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Kormo Mukhi'),
            Text(
                'A simple, secure and reliable way for chatting and connect with others'),
          ],
        ),
      ),
    );
  }
}