import 'dart:ui';

import 'package:expense_app/provider/auth.dart';
import 'package:expense_app/widget/CustomElevatedButton.dart';
import 'package:expense_app/widget/CustomTextField.dart';
import 'package:expense_app/widget/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _email,
              hintText: 'Enter Email',
            ),
            CustomTextField(
              controller: _password,
              hintText: 'Enter Password',
            ),
            !showConfirmPassword
                ? Padding(
                    padding: const EdgeInsets.only(left: 230),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                      ),
                    ),
                  )
                : Container(),
            showConfirmPassword
                ? CustomTextField(
                    controller: _confirmPassword,
                    hintText: 'Confirm Password',
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CustomElevatedButton(
                text: 'Log In',
                onPressed: () {
                  if (showConfirmPassword == false) {
                    Provider.of<Auth>(context, listen: false)
                        .signIn(_email.text, _password.text)
                        .catchError((error) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            error.toString(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Okay'),
                            )
                          ],
                        ),
                      );
                    });
                  } else {
                    if (_password.text == _confirmPassword.text) {
                      Provider.of<Auth>(context, listen: false)
                          .signup(_email.text, _password.text)
                          .catchError((error) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              error.toString(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Okay'),
                              )
                            ],
                          ),
                        );
                      });
                    }
                  }
                },
              ),
            ),
            const Text(
              'or',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showConfirmPassword = !showConfirmPassword;
                });
              },
              child: showConfirmPassword
                  ? const Text('Sign In')
                  : const Text('Sign Up'),
            ),
            const SizedBox(
              height: 10,
            ),
            const LoginButton(),
          ],
        ),
      ),
    );
  }
}
