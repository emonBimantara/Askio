import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Features/Home/Controller/home_controller.dart';

void showDeleteQuizDialog(String quizId, HomeController controller) {
  Get.dialog(
    Dialog(
      backgroundColor: const Color(0xFFF5EDE2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 40,
            ),

            const SizedBox(height: 12),

            const Text(
              "Delete Quiz",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Are you sure want to delete this Quiz?",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.deleteQuiz(quizId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}