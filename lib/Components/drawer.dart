import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kormomukhi/chatlist.dart';
import 'package:kormomukhi/home.dart';
import 'package:kormomukhi/login.dart';
import 'package:kormomukhi/registration.dart';

Widget drawer(context) {
  final auth = FirebaseAuth.instance;

  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage('${auth.currentUser?.photoURL}'),
          ),
        ),
        ListTile(
          title: Text('Chats'),
          onTap: () async{


            final auth=FirebaseAuth.instance.currentUser;
            final chats = await FirebaseFirestore.instance.collection('chats').get();
            final allChats = chats.docs.map((doc) => doc.data()).toList();
            List<Map<String,dynamic>> selectedChats=[];
            for(Map<String,dynamic> c in allChats){
              if(c['chatId'].contains('${auth?.uid}')){
                selectedChats.add(c);
              }
            }
            // print('Selected chats=${selectedChats}');
            final users = await FirebaseFirestore.instance.collection('users').where('uid',isEqualTo: '${auth?.uid}').get();
            final user = users.docs.map((doc) => doc.data()).toList();
            String self=user[0]['registerAs'];
            // print('Register as $self');

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatList(chats: selectedChats, self: self)));
          },
        ),
        Divider(),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            auth.signOut().then((value) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LogIn()));
            }).onError((error, stackTrace) {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('An error occured'),
                    content: Text('${error.toString()}'),
                  ));
            });
          },
        ),
        Divider(),
      ],
    ),
  );
}