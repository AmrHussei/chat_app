import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widget/message_stream_builder.dart';

late User signInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String? messageText;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        debugPrint('========================-====');

        debugPrint(signInUser.email);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            SizedBox(
              height: 25,
              child: Image.asset('images/logo.png'),
            ),
            const SizedBox(width: 10),
            const Text('Message me')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'welcom_screen', (route) => false);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: MessageStreamBuilder()),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: const Border(
                top: BorderSide(color: Colors.orange),
                bottom: BorderSide(color: Colors.orange),
                left: BorderSide(color: Colors.orange),
                right: BorderSide(color: Colors.orange),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Write your message here...',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      messageText != null
                          ? await _firestore.collection('messages').add({
                              'text': messageText,
                              'sender': signInUser.email,
                              'time': FieldValue.serverTimestamp()
                            })
                          : null;
                      messageTextController.clear();
                      setState(() {
                        messageText = null;
                      });
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}
