import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.textInputType = TextInputType.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: hintText,
        ),
      ),
    );
  }
}
