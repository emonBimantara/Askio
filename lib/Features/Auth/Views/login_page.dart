import 'package:askio/Components/custom_button.dart';
import 'package:askio/Components/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Welcome Back! Glad to See You, Again!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 30),
            Column(
              children: [
                CustomTextfield(
                  hintText: "Enter your email",
                  obscureText: false,
                  controller: emailController,
                ),
                SizedBox(height: 20),
                CustomTextfield(
                  hintText: "Enter your password",
                  obscureText: true,
                  controller: passwordController,
                  suffixIconPath: 'assets/icons/eye.png',
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F4F4F),
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(customText: 'Login'),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Or Login With',
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
