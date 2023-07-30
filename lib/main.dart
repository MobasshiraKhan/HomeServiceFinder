import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kormomukhi/home.dart';
import 'package:kormomukhi/sendmail.dart';
import 'Values/localauth.dart';
import 'login.dart';

bool isAuth = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final isAuthenticated = await LocalAuthApi.authenticate();

  if (isAuthenticated) {
    isAuth = true;
    if (isAuth) print('done');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return isAuth
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kormo Mukhi',
            home: auth.currentUser == null ? LogIn() : BottomTabBar(),
            // home: SendMail(
            //   mailtosend: '',
            // ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kormo Mukhi',
            home: Container(),
            // home: SendMail(
            //   mailtosend: '',
            // ),
          );
  }
}
