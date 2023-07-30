import 'package:flutter/material.dart';
import 'package:kormomukhi/chatscreen1.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.chats, required this.self})
      : super(key: key);
  final chats, self;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late final chats, self;
  @override
  void initState() {
    super.initState();
    chats = widget.chats;
    self = widget.self;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.separated(
          itemCount: chats.length,
          itemBuilder: (_, i) {
            return ListTile(
              title: Text(
                  '${self == 'Seller' ? chats[i]['sender'] : chats[i]['user']}'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatScreen1(
                            chat: chats[i],
                            self: widget.self,
                            worker: chats[i]['sender'])));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
    );
  }
}
