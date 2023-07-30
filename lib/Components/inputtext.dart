import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  String label;
  final action;
  final ktype;
  final obsecure;

  InputText(
      {Key? key,
      required this.label,
      required this.action,
      this.ktype = TextInputType.text,
      this.obsecure = false})
      : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        onChanged: widget.action,
        keyboardType: widget.ktype,
        obscureText: true,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.label,
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
        ),
      ),
    );
  }
}