import 'package:askio/Components/custom_button.dart';
import 'package:askio/Components/custom_textfield.dart';
import 'package:askio/Features/Auth/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              Text(
                'Welcome Back! Glad To See You, Again!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),

              SizedBox(height: 30),

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

              SizedBox(height: 25),

              Obx(
                () => CustomButton(
                  customText: 'Login',
                  isLoading: authController.isLoading.value,
                  onTap: () {
                    authController.login(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                ),
              ),

              SizedBox(height: 40),

              GestureDetector(
                onTap: () => Get.toNamed("/register"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Register Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2120FF),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
