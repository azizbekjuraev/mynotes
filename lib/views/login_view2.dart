// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/show_alert_dialog.dart';
import 'package:provider/provider.dart';
import '../data/user_data.dart';

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
      height: 20,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
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
                TextButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    try {
                      final email = _email.text;
                      final password = _password.text;
                      final userCredentials = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      print('user data');
                      print(userCredentials);
                      // create a userdata obj
                      final userData = UserData(userCredentials.user?.email,
                          userCredentials.user?.displayName);

                      // use provider to update the user data
                      context.read<UserDataProvider>().updateUserData(userData);

                      showAlertDialog(context, 'Success', 'Logged in',
                          showProgress: true);
                      Future.delayed(const Duration(seconds: 1), () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user?.emailVerified == true) {
                          Navigator.pushNamed(context, './notes-view/');
                        } else {
                          Navigator.pushNamed(context, './verify-email/');
                        }
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showAlertDialog(context, 'Error', 'User not found!');
                      } else if (e.code == 'wrong-password') {
                        showAlertDialog(context, 'Error',
                            'Your password is incorrect, try again!');
                      } else if (e.code == 'network-request-failed') {
                        showAlertDialog(context, 'Network Request Failed.',
                            'You do not have a proper network connection.');
                      } else if (e.code == 'email-already-in-use') {
                        showAlertDialog(context, "Error",
                            'The email address is already in use by another account.');
                      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                        showAlertDialog(
                            context, "Error", "Register first, then log in!");
                      }
                    }
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, './register/');
                    },
                    child: const Text('Not registered yet? Register here!'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
