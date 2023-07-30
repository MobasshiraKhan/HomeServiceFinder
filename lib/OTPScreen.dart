import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinput/pinput.dart';
import 'Components/custombutton.dart';
import 'Values/position.dart';
import 'homepage.dart';
import 'package:kormomukhi/home.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class OTPScreen extends StatefulWidget {
  final String number;

  const OTPScreen({Key? key, required this.number}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 30),
                  child: Image.asset(
                    'assets/images/otp.png',
                  ),
                ),
                Text(
                  'Please wait while we verify the number ' + widget.number,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Pinput(
                  onCompleted: (pin) => print(pin),
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                ),
                SizedBox(
                  height: 35,
                ),
                CustomButton(
                  txt: 'Submit',
                  action: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomTabBar()),
                    );
                  },
                  clr: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}