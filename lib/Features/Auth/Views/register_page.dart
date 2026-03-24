import 'package:askio/Components/custom_button.dart';
import 'package:askio/Components/custom_textfield.dart';
import 'package:askio/Features/Auth/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  // State untuk menyimpan pilihan role, default: student
  String selectedRole = 'student'; 

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Hello! Register To Get Started',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),

              const SizedBox(height: 30),

              CustomTextfield(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),

              const SizedBox(height: 20),

              CustomTextfield(
                hintText: "Enter your email",
                obscureText: false,
                controller: emailController,
              ),

              const SizedBox(height: 20),

              CustomTextfield(
                hintText: "Enter your password",
                obscureText: true,
                controller: passwordController,
                suffixIconPath: 'assets/icons/eye.png',
              ),

              const SizedBox(height: 20),

              CustomTextfield(
                hintText: "Confirm your password",
                obscureText: true,
                controller: passwordConfirmController,
                suffixIconPath: 'assets/icons/eye.png',
              ),

              const SizedBox(height: 20),

              // Dropdown untuk memilih Role
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF7F8F9), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2120FF)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'student',
                    child: Text('Register as Student', style: TextStyle(color: Colors.black87)),
                  ),
                  DropdownMenuItem(
                    value: 'teacher',
                    child: Text('Register as Teacher', style: TextStyle(color: Colors.black87)),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
              ),

              const SizedBox(height: 25),

              Obx(
                () => CustomButton(
                  customText: "Register",
                  isLoading: authController.isLoading.value,
                  onTap: () {
                    authController.register(
                      usernameController.text,
                      emailController.text,
                      passwordController.text,
                      passwordConfirmController.text,
                      selectedRole, // Kirim role ke controller
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Or Register With',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F4F4F),
                      ),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () => Get.toNamed("/login"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Already have an account?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Login Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2120FF),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}