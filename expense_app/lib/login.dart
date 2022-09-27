import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton.extended(
        onPressed: () {},
        icon: Image.asset(
          'assets/images/google_logo.png',
          width: 30,
          height: 30,
        ),
        label: const Text('Sign in with Google'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}
