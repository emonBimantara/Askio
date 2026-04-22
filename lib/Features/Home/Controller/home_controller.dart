import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Auth/Controller/auth_controller.dart';
import '../Model/quiz_model.dart';
import '../Services/quiz_service.dart';

class HomeController extends GetxController {
  final QuizService _quizService = QuizService();
  final UserService _userService = UserService();

  final AuthController authController = Get.find();

  var quizzes = <QuizModel>[].obs;
  var isLoading = true.obs;
  var userRole = 'student'.obs;

  final TextEditingController codeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  Future<void> initData() async {
    try {
      isLoading(true);
      final user = authController.user;
      if (user != null) {
        userRole.value = await _userService.getUserRole(user.uid);
        await refreshQuizzes();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshQuizzes() async {
    final user = authController.user;

    if (userRole.value == 'teacher') {
      final data = await _quizService.getQuizzes(teacherId: user?.uid);
      quizzes.assignAll(data);
    } else {
      final data = await _quizService.getQuizzes(studentId: user?.uid);
      quizzes.assignAll(data);
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      await _quizService.deleteQuiz(quizId);
      await refreshQuizzes();
      Get.snackbar("Success", "Quiz deleted");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete the quiz");
    }
  }

  Future<void> joinQuiz() async {
    final code = codeController.text.trim();
    final user = authController.user;

    if (code.isEmpty) {
      Get.snackbar("Warning", "Code is not belong to empty");
      return;
    }

    if (user != null) {
      isLoading(true);
      String studentName =
          user.displayName ?? "Student ${user.uid.substring(0, 4)}";

      bool success = await _quizService.joinQuizByCode(
        code,
        user.uid,
        studentName,
      );

      if (success) {
        codeController.clear();
        Get.back();
        await refreshQuizzes();
        Get.snackbar("Success", "You successfuly join a quiz!");
      }
      isLoading(false);
    }
  }
}
