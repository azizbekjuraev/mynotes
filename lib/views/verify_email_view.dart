// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/show_alert_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your email'),
      ),
      body: Column(
        children: [
          const Text('Verify your address'),
          TextButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                print(user);
                showAlertDialog(context, 'Success',
                    'Verification link has been sent to your email address!');
                Future.delayed(const Duration(seconds: 30), () {
                  Navigator.pushNamed(context, './login/');
                });
              } catch (e) {
                showAlertDialog(context, 'Error', "$e");
              }
            },
            child: const Text('Send email verification'),
          ),
        ],
      ),
    );
  }
}
