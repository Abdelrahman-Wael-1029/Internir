import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticateEmail extends StatefulWidget {
  const AuthenticateEmail({super.key});

  @override
  State<AuthenticateEmail> createState() => _AuthenticateEmailState();
}

class _AuthenticateEmailState extends State<AuthenticateEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _checkVerification() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not verified yet!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'A verification email has been sent. Please verify your email.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkVerification,
              child: const Text('I have verified'),
            ),
          ],
        ),
      ),
    );
  }
}
