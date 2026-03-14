import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final String? suffixIconPath;

  const CustomTextfield({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.obscureText,
    required this.controller,
    this.suffixIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIconPath != null
            ? Padding(
                padding: EdgeInsets.all(12.0),
                child: Image.asset(suffixIconPath!, width: 20, height: 20),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
