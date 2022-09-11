import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widget/my_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late String email;
  late String password;
  bool showSpinner = false;
  bool displayPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign in'),
          backgroundColor: Colors.yellow[900],
        ),
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 160, child: Image.asset('images/logo.png')),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      hintText: 'Enter your Email',
                      icon: Icon(Icons.email),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: displayPassword,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            displayPassword = !displayPassword;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye),
                        color:
                            displayPassword ? Colors.grey : Colors.blueAccent,
                      ),
                      icon: const Icon(Icons.lock),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15)),
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    color: Colors.yellow[900]!,
                    title: 'Sign in',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'chat_screen', (route) => false);
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        if (e.code == 'user-not-found') {
                          debugPrint('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          debugPrint('Wrong password provided for that user.');
                        }
                      }
                    })
              ],
            ),
          ),
        ));
  }
}
