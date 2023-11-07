// ignore_for_file: use_build_context_synchronously

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import '../utils/show_alert_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const height = SizedBox(
      height: 15,
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Registration'),
                      height,
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      height,
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        controller: _password,
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: true,
                      ),
                      height,
                      TextButton(
                        child: const Text('Register'),
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            // FirebaseAuth.instance.currentUser!.emailVerified ==
                            //     true;
                            showAlertDialog(
                                context, 'Success', 'User registered!');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'network-request-failed') {
                              showAlertDialog(
                                  context,
                                  'Network Request Failed, Try Again Later',
                                  'You do not have a proper network connection.');
                            } else if (e.code == 'weak-password') {
                              showAlertDialog(context, 'Error',
                                  'Password should be at least 6 characters');
                            } else if (e.code == 'email-already-in-use') {
                              showAlertDialog(context, 'Error',
                                  'The email address is already in use by another account.');
                            } else {
                              showAlertDialog(context, 'Error',
                                  'Invalid email address, make sure its correct!');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              default:
                return const Text('Loading...');
            }
          },
        ));
  }
}
