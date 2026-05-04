import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:askio/Features/Quiz/Controller/question_controller.dart';

void showSubmitDialog({
  required QuestionController controller,
  required String quizId,
  required String quizTitle,
  required String userId,
}) {
  if (!controller.allAnswered) {
    Get.snackbar(
      "Hold on!",
      "Please answer all questions before submitting.",
    );
    return;
  }

  Get.defaultDialog(
    title: "Submit Quiz?",
    middleText: "You will not be able to change your answers after this.",
    textConfirm: "Submit",
    textCancel: "Check Again",
    confirmTextColor: Colors.white,
    buttonColor: const Color(0xFF2120FF),
    onConfirm: () async {
      Get.back();
      controller.isSubmitting.value = true;

      final score = controller.calculateScore();

      await controller.submitQuiz(
        quizId: quizId,
        userId: userId,
        quizTitle: quizTitle,
      );

      Get.snackbar("Quiz Finished", "Your score: $score");
      Get.offAllNamed('/home');
      controller.reset();
    },
  );
}