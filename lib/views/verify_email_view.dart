// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/show_alert_dialog.dart';
import 'dart:async'; // Import the dart:async package

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  // Define a timer variable
  late Timer _timer;
  int _remainingSeconds = 30; // Initialize with 30 seconds
  bool verificationSent = false;

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Verify your address',
              style: TextStyle(fontSize: 30),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  verificationSent = !verificationSent;
                  showAlertDialog(context, 'Success',
                      'Verification link has been sent to your email address!');

                  // Start a 30-second timer
                  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    setState(() {
                      _remainingSeconds -= 1;
                      if (_remainingSeconds == 0) {
                        timer.cancel();
                        Navigator.pushNamed(context, './login/');
                      }
                    });
                  });
                } catch (e) {
                  showAlertDialog(context, 'Error', "$e");
                }
              },
              child: const Text('Send email verification'),
            ),
            if (verificationSent)
              Text(
                '$_remainingSeconds',
                style: const TextStyle(fontSize: 70),
              ),
            TextButton(
                onPressed: () {
                  // Cancel the timer if the user presses the "Login" button
                  _timer?.cancel();
                  Navigator.pushNamed(context, './login/');
                },
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
