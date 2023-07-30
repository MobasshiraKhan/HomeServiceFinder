import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kormomukhi/registration.dart';
import 'package:flutter/material.dart';
import 'package:kormomukhi/sendmail.dart';
import 'Components/custombutton.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseFirestore.instance;
  bool remember = false;
  String _code = '', email = '', _pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(36, 37, 39, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: Image.asset("assets/images/login.jpeg")),
                SizedBox(
                  height: 100,
                ),
                const Text(
                  'User Log In',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                TextField(
                  onChanged: (String text) {
                    email = text;
                  },
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
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
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (String text) {
                    _pass = text;
                  },
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
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
                CustomButton(
                  txt: 'Log In',
                  clr: Colors.green,
                  action: () {
                    auth
                        .signInWithEmailAndPassword(
                            email: email, password: _pass)
                        .then(
                      (value) {
                        ref
                            .collection('users')
                            .doc('${auth.currentUser?.uid}')
                            .get()
                            .then((value) {
                          if (value.exists) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendMail(
                                          mailtosend: email,
                                        )));
                          } else {
                            auth.signOut();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Your account is deactivated')));
                          }
                        }).onError((error, stackTrace) {
                          auth.signOut();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Error occurred or Your account is deactivated')));
                        });
                      },
                    ).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                  },
                ),
                Center(
                  child: TextButton(
                    child: Text(
                      "Forget Password??",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {},
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.grey,
                        height: 01,
                      ),
                    ),
                    Text(
                      'OR',
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.grey,
                        height: 01,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: CustomButton(
                    txt: 'Register',
                    clr: Colors.blue,
                    action: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Registration()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
