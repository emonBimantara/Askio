import 'package:askio/Features/Auth/Views/login_page.dart';
import 'package:askio/Features/Auth/Views/register_page.dart';
import 'package:askio/Features/Start/onboarding_page.dart';
import 'package:askio/Features/Start/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Askio',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5EDE2),
        fontFamily: "Inter",
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashPage()),
        GetPage(name: '/onboarding', page: () => OnboardingPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage())
      ],
    );
  }
}
