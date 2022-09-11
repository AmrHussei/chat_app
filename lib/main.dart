import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chat app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _auth.currentUser != null ? 'chat_screen' : 'welcom_screen',
      routes: {
        'welcom_screen': (context) => const WelcomeScreen(),
        'sign_in': (context) => const SignIn(),
        'sign_up': (context) => const SignUp(),
        'chat_screen': (context) => const ChatScreen(),
      },
    );
  }
}
