import 'package:askio/Features/Auth/Views/forgot_email_page.dart';
import 'package:askio/Features/Auth/Views/login_page.dart';
import 'package:askio/Features/Auth/Views/register_page.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Home/Views/add_quiz_page.dart';
import 'package:askio/Features/Home/Views/history_detail_page.dart';
import 'package:askio/Features/Home/Views/home_page.dart';
import 'package:askio/Features/Home/Views/quiz_preview_page.dart';
import 'package:askio/Features/Quiz/Model/quiz_result_model.dart';
import 'package:askio/Features/Quiz/View/question_page.dart';
// import 'package:askio/Features/Start/onboarding_page.dart';
import 'package:askio/Features/Start/splash_page.dart';
import 'package:askio/Routes/app_routes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashPage:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case AppRoutes.loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRoutes.registerPage:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case AppRoutes.homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case AppRoutes.addQuizPage:
        return MaterialPageRoute(builder: (_) => AddQuizPage());
      case AppRoutes.quizPreviewPage:
        final quiz = settings.arguments as QuizModel;
        return MaterialPageRoute(builder: (_) => QuizPreviewPage(quiz: quiz));
      case AppRoutes.questionPage:
        final quiz = settings.arguments as QuizModel;
        return MaterialPageRoute(builder: (_) => QuestionPage(quiz: quiz));
      case AppRoutes.forgotEmailPage:
        return MaterialPageRoute(builder: (_) => ForgotEmailPage());
      case AppRoutes.historyDetailPage:
        final result = settings.arguments as QuizResultModel;
        return MaterialPageRoute(
          builder: (_) => HistoryDetailPage(result: result),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text("Page Not Found"))),
        );
    }
  }
}
