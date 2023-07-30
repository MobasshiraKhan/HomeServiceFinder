import 'package:flutter/material.dart';

class ServiceCard extends StatefulWidget {
  final img, color, title, action, coming;

  const ServiceCard(
      {Key? key,
      this.img = 'assets/images/allservice.png',
      this.color = Colors.blue,
      this.title = 'All Service',
      this.coming = true,
      required this.action})
      : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action,
      child: Container(
        height: MediaQuery.of(context).size.width / 2,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.img,
                  height: 70,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  'Service coming soon',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
