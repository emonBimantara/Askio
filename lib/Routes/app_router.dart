import 'package:askio/Features/Auth/Views/login_page.dart';
import 'package:askio/Features/Auth/Views/register_page.dart';
import 'package:askio/Features/Home/Views/add_quiz_page.dart';
import 'package:askio/Features/Home/Views/home_page.dart';
// import 'package:askio/Features/Start/onboarding_page.dart';
import 'package:askio/Features/Start/splash_page.dart';
import 'package:askio/Routes/app_routes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashPage:
        return MaterialPageRoute(builder: (_) => SplashPage());
      // case AppRoutes.onboardingPage:
      //   return MaterialPageRoute(builder: (_) => OnboardingPage());
      case AppRoutes.loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRoutes.registerPage:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case AppRoutes.homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case AppRoutes.addQuizPage:
        return MaterialPageRoute(builder: (_) => AddQuizPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text("Page Not Found"))),
        );
    }
  }
}
