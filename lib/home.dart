import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kormomukhi/account.dart';
import 'package:kormomukhi/bookings.dart';
import 'package:kormomukhi/homepage.dart';
import 'package:kormomukhi/services.dart';
import 'package:flutter/material.dart';
import 'Components/tabbarmaterialwidget.dart';
import 'Models/User.dart';
import 'notifications.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({Key? key}) : super(key: key);

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int index = 0;

  final pages = <Widget>[
    Services(),
    Notifications(),
    MyBookings(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        body: pages[index],
        bottomNavigationBar: TabBarMaterialWidget(
          index: index,
          onChangedTab: (int index) {
            setState(() {
              this.index = index;
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            LocationPermission permission;
            permission = await Geolocator.checkPermission();
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              //nothing
            }
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.low);
            print("Position: $position");
            try {
              QuerySnapshot<Map<String, dynamic>> snapshot =
                  await FirebaseFirestore.instance.collection("users").get();
              final users = snapshot.docs
                  .map((docSnapshot) =>
                      CurrentUser.fromDocumentSnapshot(docSnapshot))
                  .toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(position: position, users: users)),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Something error occured')));
            }
          },
          child: Icon(Icons.search),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
}
