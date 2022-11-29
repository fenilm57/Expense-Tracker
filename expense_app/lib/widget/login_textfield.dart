import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField(
      {super.key,
      required this.controller,
      required this.hintTexts,
      required this.textInputType,
      required this.icon,
      required this.secure});
  final TextEditingController controller;
  final String hintTexts;
  final TextInputType textInputType;
  final IconData icon;
  final bool secure;

  @override
  Widget build(BuildContext context) {
    // password textfield
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: TextField(
        obscureText: secure,
        controller: controller,
        keyboardType: textInputType,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 249, 249, 249),
          hintText: hintTexts,
          hintStyle: const TextStyle(
            color: Color(0xff4B57A3),
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color(0xff4B57A3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color(0xff4B57A3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color(0xff4B57A3),
            ),
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xff4B57A3),
          ),
        ),
      ),
    );
  }
}
