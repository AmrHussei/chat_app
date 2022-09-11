import 'package:chat_app/widget/message_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

final _firestore = FirebaseFirestore.instance;

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messagesWidgets = [];
          if (!snapshot.hasData) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }
          QuerySnapshot? messagesdata = snapshot.data;

          if (messagesdata != null) {
            dynamic messages = messagesdata.docs.reversed;
            for (var message in messages) {
              final messageText = message.get('text');
              final String messageSender = message.get('sender');
              final currentUser = signInUser.email;

              final messageWidget = MessageLine(
                messageText: messageText,
                messageSender: messageSender,
                isMe: currentUser == messageSender,
              );
              messagesWidgets.add(messageWidget);
            }
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              children: messagesWidgets,
            ),
          );
        });
  }
}
