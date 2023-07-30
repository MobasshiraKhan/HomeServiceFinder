import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String txt;
  final action;
  final clr;
  CustomButton(
      {Key? key,
      required this.txt,
      required this.action,
      this.clr = Colors.green})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 80, minWidth: MediaQuery.of(context).size.width),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: clr, elevation: 0),
          onPressed: action,
          child: Text(
            txt,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}