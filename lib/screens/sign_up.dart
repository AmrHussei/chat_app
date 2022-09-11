import 'package:chat_app/widget/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email;
  late String password;
  bool displayPassword = true;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
          backgroundColor: Colors.blue[900],
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
                    color: Colors.blue[800]!,
                    title: 'Sign up',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        print(credential);
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'chat_screen', (route) => false);
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        if (e.code == 'weak-password') {
                          debugPrint('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          debugPrint(
                              'The account already exists for that email.');
                        }
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        print(e);
                      }
                    })
              ],
            ),
          ),
        ));
  }
}
