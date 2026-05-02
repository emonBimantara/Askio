import 'package:askio/Features/Quiz/Controller/question_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionNumberBar extends StatelessWidget {
  const QuestionNumberBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuestionController>();

    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(controller.questions.length, (index) {
          final isActive = controller.currentIndex.value == index;

          final isAnswered = controller.userAnswers[index] != null;

          return GestureDetector(
            onTap: () {
              controller.goToQuestion(index);
            },
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? Colors.black
                    : isAnswered
                    ? Colors.black.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.2),
              ),
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
