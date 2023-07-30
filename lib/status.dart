import 'package:flutter/material.dart';
import 'Values/values.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {

  List<String> litems = ["1","2","Third","4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: litems.length,
          itemBuilder: (context, int index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage('https://www.w3schools.com/howto/img_avatar.png'),
              ),
              title: Text('User'),
              subtitle: Text('Last Message'),
              trailing: Text('time'),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          backgroundColor: clr,
          onPressed: (){}
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
