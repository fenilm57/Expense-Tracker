import 'package:expense_app/auth/google_signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton.extended(
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.googleLogin();
          print(provider.user.email);
        },
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
