import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kormomukhi/login.dart';
import 'package:kormomukhi/notifications_admin.dart';
import 'Components/drawer.dart';
import 'registration.dart';
import 'package:kormomukhi/service.dart';

import 'Components/servicecard.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  CarouselController _controller = CarouselController();

  List<Widget> _carouselItems = [
    Image.asset('assets/images/rokomari-discount.jpeg'),
    Image.asset('assets/images/chaldal-discount.jpeg'),
    Image.asset('assets/images/pathao-discount.jpeg'),
    Image.asset('assets/images/uber-discount.jpeg'),
  ];

  static const List service = [
    {'title': '', 'image': 'assets/images/bikroy.jpg'},
    {'title': '', 'image': 'assets/images/makeup.jpg'},
    {'title': '', 'image': 'assets/images/chaldal.jpg'},
    {'title': '', 'image': 'assets/images/pathao.png'},
    {'title': '', 'image': 'assets/images/rokomari.png'},
    {'title': '', 'image': 'assets/images/uber.png'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        title: Text('Home Service Finder '),
        titleSpacing: 0,
        backgroundColor: Colors.blue[400],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AdminNotifications()));
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                child: CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: _carouselItems,
                ),
              ),
              ServiceCard1(
                color: Colors.blue[400],
                img: 'assets/images/home-service.png',
                title: 'All Service',
                action: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServicePage(
                                title: 'All Service',
                              )));
                },
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: service.length,
                itemBuilder: (context, index) {
                  return ServiceCard(
                    color: Colors.blue[400],
                    img: service[index]['image'],
                    title: service[index]['title'],
                    action: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ServicePage(
                      //               title: 'All Service',
                      //             )));
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard1 extends StatefulWidget {
  final img, color, title, action;

  const ServiceCard1(
      {Key? key,
      this.img = 'assets/images/allservice.png',
      this.color = Colors.blue,
      this.title = 'All Service',
      required this.action})
      : super(key: key);

  @override
  State<ServiceCard1> createState() => _ServiceCard1State();
}

class _ServiceCard1State extends State<ServiceCard1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action,
      child: Container(
        height: MediaQuery.of(context).size.width / 2,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.color,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 15.0,
              spreadRadius: 1.0,
              offset: Offset(
                1.0,
                1.0,
              ),
            )
          ],
        ),
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}