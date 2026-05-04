import 'package:askio/Features/Quiz/Model/quiz_result_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryAttemptItem extends StatelessWidget {
  final int attemptNumber;
  final QuizResultModel attempt;

  const HistoryAttemptItem({
    super.key,
    required this.attemptNumber,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    String dateStr = DateFormat(
      'dd MMM, HH:mm',
    ).format(attempt.createdAt ?? DateTime.now());

    return GestureDetector(
      onTap: () {
        Get.toNamed('/historyDetailPage', arguments: attempt);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attempt $attemptNumber",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    value: attempt.score / 100,
                    backgroundColor: Colors.grey[200],
                    color: attempt.score >= 70 ? Colors.green : Colors.blue,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  dateStr,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "${attempt.score}",
                  style: TextStyle(
                    color: attempt.score >= 70
                        ? Colors.green
                        : const Color(0xFF2120FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "/100",
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
