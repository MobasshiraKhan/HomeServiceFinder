import 'package:kormomukhi/OTPScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kormomukhi/homepage.dart';
import 'package:kormomukhi/sendmail.dart';
import 'Components/CustomButton.dart';
import 'Values/values.dart';
import 'home.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _LogInState();
}

class _LogInState extends State<Registration> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseFirestore.instance.collection('users');
  bool remember = false;
  String _username = '', _email = '';
  String _nid = '';
  String _pass = '';
  String _cpass = '';
  String _phone = '';
  String registerAs = 'Seller';
  String registerAsSeller = 'Service Seller';
  String registerAsSellerRole = 'Seller Role';
  String registerAsServiceSeller = 'Registration By API';
  String registerAsStoreSeller = 'FBK';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(36, 37, 39, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(36, 37, 39, 1),
        elevation: 0,
        titleSpacing: 0,
        title: Text('Registration'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton(
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.grey,
                isExpanded: true,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                value: registerAs!,
                items: [
                  DropdownMenuItem(child: Text("Seller"), value: "Seller"),
                  DropdownMenuItem(child: Text("Customer"), value: "Customer")
                ],
                onChanged: (String? value) {
                  setState(() {
                    registerAs = value!;
                  });
                },
              ),
              if (registerAs == "Seller")
                DropdownButton(
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey,
                  isExpanded: true,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  value: registerAsSeller!,
                  items: [
                    DropdownMenuItem(
                        child: Text("Service Seller"), value: "Service Seller"),
                    DropdownMenuItem(
                        child: Text("Product Seller"), value: "Product Seller")
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      registerAsSeller = value!;
                    });
                  },
                ),
              if (registerAsSeller == "Service Seller" &&
                  registerAs == 'Seller')
                DropdownButton(
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey,
                  isExpanded: true,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  value: registerAsSellerRole!,
                  items: [
                    DropdownMenuItem(
                        child: Text("Seller Role"), value: "Seller Role"),
                    DropdownMenuItem(child: Text("Plumber"), value: "Plumber"),
                    DropdownMenuItem(child: Text("Nurse"), value: "Nurse"),
                    DropdownMenuItem(child: Text("Chef"), value: "Chef"),
                    DropdownMenuItem(child: Text("Cleaner"), value: "Cleaner"),
                    DropdownMenuItem(
                        child: Text("Mechanic"), value: "Mechanic"),
                    DropdownMenuItem(
                        child: Text("Electrician"), value: "Electrician"),
                    DropdownMenuItem(
                        child: Text("Carpenter"), value: "Carpenter"),
                    DropdownMenuItem(
                        child: Text("AC Mechanic"), value: "AC Mechanic"),
                    DropdownMenuItem(child: Text("Painter"), value: "Painter"),
                    DropdownMenuItem(
                        child: Text("TV Mechanic"), value: "TV Mechanic"),
                    DropdownMenuItem(
                        child: Text("Event Planner"), value: "Event Planner"),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      registerAsSellerRole = value!;
                    });
                  },
                ),
              if (registerAsSeller == "Product Seller")
                DropdownButton(
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey,
                  isExpanded: true,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  value: registerAsServiceSeller!,
                  items: [
                    DropdownMenuItem(
                        child: Text("Registration By API"),
                        value: "Registration By API"),
                    DropdownMenuItem(
                        child: Text("Registration By Store"),
                        value: "Registration By Store")
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      registerAsServiceSeller = value!;
                    });
                  },
                ),
              if (registerAsServiceSeller == "Registration By Store")
                DropdownButton(
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey,
                  isExpanded: true,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  value: registerAsStoreSeller!,
                  items: [
                    DropdownMenuItem(child: Text("FBM"), value: "FBM"),
                    DropdownMenuItem(child: Text("FBK"), value: "FBK")
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      registerAsStoreSeller = value!;
                    });
                  },
                ),
              space,
              TextField(
                onChanged: (String text) {
                  _username = text;
                },
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  hintText: "User Name",
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
              space,
              TextField(
                onChanged: (String text) {
                  _email = text;
                },
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: "Email",
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
              space,
              TextField(
                onChanged: (String text) {
                  _nid = text;
                },
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'NID',
                  hintText: "NID",
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
              space,
              TextField(
                onChanged: (String text) {
                  _phone = text;
                },
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: "Phone Number",
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
              space,
              TextField(
                onChanged: (String text) {
                  _pass = text;
                },
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: "Password",
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
              space,
              TextField(
                onChanged: (String text) {
                  _cpass = text;
                },
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: "Confirm Password",
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
              space,
              CustomButton(
                txt: 'Register',
                action: () {
                  if (_pass == _cpass) {
                    auth
                        .createUserWithEmailAndPassword(
                            email: _email, password: _pass)
                        .then((value) {
                      final user = auth.currentUser;
                      user?.updateDisplayName(_username);
                      user?.updatePhotoURL(
                          'https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper-thumbnail.png');
                      ref.doc('${user?.uid}').set({
                        'uid': user?.uid,
                        'name': _username,
                        'email': _email,
                        'nid': _nid,
                        'phone': _phone,
                        'registerAs': registerAs,
                        'registerAsSeller': registerAsSeller,
                        'registerAsSellerRole': registerAsSellerRole,
                        'registerAsServiceSeller': registerAsServiceSeller,
                        'registerAsStoreSeller': registerAsStoreSeller,
                        'image':
                            'https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper-thumbnail.png',
                        'verified': false,
                      }).then((value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SendMail(mailtosend: _email))));
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Passwords do not match')));
                  }
                },
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text(
                    "Already have and account?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogIn()),
                        );
                      },
                      child: const Text('Log In')),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
