import 'package:askio/Features/Home/Controller/history_detail_controller.dart';
import 'package:askio/Features/Quiz/Model/quiz_result_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryQuestionNumberBar extends StatelessWidget {
  final List<ResultDetailModel> details;
  final String tag;

  const HistoryQuestionNumberBar({super.key, required this.details, required this.tag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryDetailController>(tag: tag);

    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(details.length, (index) {
          final isActive = controller.currentIndex.value == index;
          final isCorrect = details[index].isCorrect;

          return GestureDetector(
            onTap: () => controller.goToQuestion(index),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isActive ? Border.all(color: Colors.black, width: 2) : null,
                color: isCorrect ? Colors.green : Colors.red,
              ),
              child: Text(
                "${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          );
        }),
      );
    });
  }
}