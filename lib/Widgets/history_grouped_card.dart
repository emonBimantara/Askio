import 'package:askio/Features/Quiz/Model/quiz_result_model.dart';
import 'package:askio/Widgets/history_atempt_item.dart';
import 'package:flutter/material.dart';

class HistoryGroupedCard extends StatelessWidget {
  final String title;
  final List<QuizResultModel> attempts;

  const HistoryGroupedCard({
    super.key,
    required this.title,
    required this.attempts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2120FF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.book_outlined, color: Color(0xFF2120FF)),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text("${attempts.length} attempts"),
          childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          children: attempts.asMap().entries.map((entry) {
            int idx = attempts.length - entry.key;
            var attempt = entry.value;

            return HistoryAttemptItem(attemptNumber: idx, attempt: attempt);
          }).toList(),
        ),
      ),
    );
  }
}