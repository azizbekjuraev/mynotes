// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../utils/show_alert_dialog.dart';
import '../firebase_options.dart';
import '../views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          title: const Text('Login'),
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
                      const Text('Login'),
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
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: const Text('Login'),
                                onPressed: () async {
                                  try {
                                    showAlertDialog(
                                        context, 'Success', 'User logged in!');
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      showAlertDialog(
                                          context, 'Error', 'User not found!');
                                    } else if (e.code == 'wrong-password') {
                                      showAlertDialog(context, 'Error',
                                          'You password is incorrect, try again!');
                                    } else if (e.code ==
                                        'network-request-failed') {
                                      showAlertDialog(
                                          context,
                                          'Network Request Failed.',
                                          'You do not have a proper network connection.');
                                    }
                                  }
                                },
                              ),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterView()));
                                  },
                                  child: const Text('Register'))
                            ],
                          )
                        ],
                      )
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
