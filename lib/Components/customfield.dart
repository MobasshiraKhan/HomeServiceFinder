import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final hintText, icon, cont, ptxt, ktype;

  const CustomTextField(
      {Key? key,
      required this.hintText,
      this.icon = null,
      this.cont = null,
      this.ptxt = '',
      this.ktype = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        keyboardType: ktype,
        obscureText: hintText == "Password",
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10.0),
            child: Text(ptxt),
          ),
          isDense: true,
          prefixIconConstraints: BoxConstraints(minHeight: 0, minWidth: 0),
          prefixStyle: TextStyle(
            color: Colors.black,
          ),
          hintText: hintText,
          labelText: hintText,
          labelStyle: TextStyle(color: Colors.grey),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.green)),
        ),
      ),
    );
  }
}