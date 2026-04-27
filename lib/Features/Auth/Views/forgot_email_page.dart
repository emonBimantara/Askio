import 'package:askio/Components/custom_button.dart';
import 'package:askio/Components/custom_textfield.dart';
import 'package:askio/Features/Auth/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotEmailPage extends StatefulWidget {
  const ForgotEmailPage({super.key});

  @override
  State<ForgotEmailPage> createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final TextEditingController emailController = TextEditingController();

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Forgot Password?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),

              const SizedBox(height: 10),

              const Text(
                'Enter your email and we will send you a password reset link.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              CustomTextfield(
                hintText: "Enter your email",
                obscureText: false,
                controller: emailController,
              ),

              const SizedBox(height: 25),

              Obx(
                () => CustomButton(
                  customText: "Send Reset Link",
                  isLoading: authController.isLoading.value,
                  onTap: () {
                    authController.resetPassword(emailController.text);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
