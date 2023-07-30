import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatScreen1 extends StatefulWidget {
  const ChatScreen1(
      {Key? key, required this.chat, required this.self, required this.worker})
      : super(key: key);
  final chat, self, worker;

  @override
  State<ChatScreen1> createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  final ref = FirebaseFirestore.instance.collection('chats');
  final rref = FirebaseFirestore.instance.collection('ratings');
  final auth = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;
  String imageUrl = '';

  TextEditingController message = TextEditingController();
  double rating = 5.0;

  late final chat, self, worker;
  @override
  void initState() {
    super.initState();
    chat = widget.chat;
    self = widget.self;
    worker = widget.worker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(self == 'Seller' ? chat['sender'] : chat['user']),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Rate this seller'),
                  content: RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.blue,
                    ),
                    onRatingUpdate: (rate) {
                      setState(() {
                        rating = rate;
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () async {
                          try {
                            await rref.add({
                              'worker': worker,
                              'rating': rating,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Rating Added')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error:$e')));
                          }
                          Navigator.pop(context);
                        },
                        child: Text('Submit')),
                  ],
                ),
              );
            },
            icon: Icon(Icons.star),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    ref.doc(chat['chatId']).collection('message').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, i) {
                          DocumentSnapshot doc = snapshot.data!.docs[i];
                          return Row(
                            children: [
                              if (doc['sender'] == '${auth?.uid}')
                                Expanded(child: Container()),
                              if (doc['type'] == 'text')
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: doc['sender'] != '${auth?.uid}'
                                          ? Colors.blue
                                          : Colors.purple,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      '${doc['message']}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              if (doc['type'] == 'image')
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: doc['sender'] != '${auth?.uid}'
                                          ? Colors.blue
                                          : Colors.purple,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Flexible(
                                      child: Image.network('${doc['message']}'),
                                    ),
                                  ),
                                ),
                              if (doc['sender'] != '${auth?.uid}')
                                Expanded(child: Container()),
                            ],
                          );
                        });
                  } else {
                    return Text("");
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final PickedFile? pickedFile = await ImagePicker()
                          .getImage(source: ImageSource.camera);
                      if (pickedFile == null) return;

                      final File image = (File(pickedFile.path));
                      var snapshot = await storage
                          .ref()
                          .child(
                              'images/${DateTime.now().microsecondsSinceEpoch}.jpg')
                          .putFile(image);
                      var downloadUrl = await snapshot.ref.getDownloadURL();
                      setState(() {
                        imageUrl = downloadUrl;
                      });

                      ref
                          .doc(chat['chatId'])
                          .collection('message')
                          .add({
                            'sender': '${auth?.uid}',
                            'sender_name': '${auth?.displayName}',
                            'message': imageUrl,
                            'type': 'image',
                            'time': DateTime.now(),
                          })
                          .then((value) => null)
                          .onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${error}')));
                          });
                    },
                    child: Icon(Icons.camera_alt),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: message,
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      ref.doc(chat['chatId']).collection('message').add({
                        'sender': '${auth?.uid}',
                        'sender_name': '${auth?.displayName}',
                        'message': message.text,
                        'type': 'text',
                        'time': DateTime.now(),
                      }).then((value) {
                        message.text = '';
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('${error}')));
                      });
                    },
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
