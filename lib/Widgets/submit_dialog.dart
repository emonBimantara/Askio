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
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orangeAccent.withValues(alpha:0.1),
      colorText: Colors.black,
    );
    return;
  }

  Get.dialog(
    Dialog(
      backgroundColor: const Color(0xFFF5EDE2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF2120FF).withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded, 
                color: Color(0xFF2120FF),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Submit Quiz?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text(
              "You've done your best! You won't be able to change your answers after this.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFF2120FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Check Again",
                      style: TextStyle(
                        color: Color(0xFF2120FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back(); 
                      controller.isSubmitting.value = true;

                      final score = controller.calculateScore();

                      await controller.submitQuiz(
                        quizId: quizId,
                        userId: userId,
                        quizTitle: quizTitle,
                      );

                      Get.snackbar(
                        "Quiz Finished",
                        "Great job! Your score: $score",
                        snackPosition: SnackPosition.TOP,
                      );

                      Get.offAllNamed('/home');
                      controller.reset();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    transitionCurve: Curves.easeInOutBack,
  );
}
