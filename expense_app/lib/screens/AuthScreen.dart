import 'dart:ui';

import 'package:expense_app/provider/auth.dart';
import 'package:expense_app/screens/home_screen.dart';
import 'package:expense_app/widget/CustomElevatedButton.dart';
import 'package:expense_app/widget/CustomTextField.dart';
import 'package:expense_app/widget/login.dart';
import 'package:expense_app/widget/login_textfield.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        // login and signup form
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Expense Tracker',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  width: 370,
                  height: 700,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      showConfirmPassword
                          ? const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4B57A3),
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4B57A3),
                              ),
                            ),
                      const SizedBox(
                        height: 80,
                      ),
                      SizedBox(
                        width: 350,
                        // new textfield for email dont use custometextfield
                        child: LoginTextField(
                          secure: false,
                          controller: _email,
                          hintTexts: 'Email',
                          icon: Icons.email,
                          textInputType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 350,
                        // new textfield for email dont use custometextfield
                        child: LoginTextField(
                          secure: true,
                          controller: _password,
                          hintTexts: 'Password',
                          icon: Icons.lock,
                          textInputType: TextInputType.visiblePassword,
                        ),
                      ),
                      showConfirmPassword
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                width: 350,
                                // new textfield for email dont use custometextfield
                                child: LoginTextField(
                                  secure: true,
                                  controller: _confirmPassword,
                                  hintTexts: 'Confirm Password',
                                  icon: Icons.lock,
                                  textInputType: TextInputType.visiblePassword,
                                ),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 30,
                      ),
                      !showConfirmPassword
                          ? Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 50,
                      ),
                      showConfirmPassword
                          ? CustomElevatedButton(
                              text: 'Sign Up',
                              onPressed: () {
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
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title:
                                          const Text('Password does not match'),
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
                                }
                              },
                            )
                          : CustomElevatedButton(
                              text: 'Login',
                              onPressed: () {
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
                              },
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          showConfirmPassword
                              ? const Text(
                                  'Already Have account?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                )
                              : const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showConfirmPassword = !showConfirmPassword;
                              });
                            },
                            child: showConfirmPassword
                                ? const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const Text(
                        'or',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const LoginButton(),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // signup form
            ],
          ),
        )),
      ),
    );
  }
}
