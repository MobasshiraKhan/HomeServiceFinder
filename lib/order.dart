import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:kormomukhi/Components/custombutton.dart';

import 'Values/values.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hire Now'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('assets/images/allservice.png'),
                    width: 150,
                  ),
                  space,
                  Text(
                    'Hiring Ali Hider',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  space,
                  Text('Location:Batar more, Rajshahi'),
                  space,
                  Text('Amount: 100 BDT'),
                  space,
                  Text('Time: 10 minutes'),
                ],
              ),
            ),
            CustomButton(
                txt: 'Hire Now',
                action: () {
                  showOkCancelAlertDialog(
                    context: context,
                    title: 'Are you Sure?',
                  );
                })
          ],
        ),
      ),
    );
  }
}
