import 'package:flutter/material.dart';

class ReviewAnswerBar extends StatelessWidget {
  final String text;
  final bool isCorrectAnswer; 
  final bool isUserChoice;    
  final bool isCorrect;       

  const ReviewAnswerBar({
    super.key,
    required this.text,
    required this.isCorrectAnswer,
    required this.isUserChoice,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey.withValues(alpha: 0.2);
    Color bgColor = Colors.transparent;
    IconData? icon;

    if (isCorrectAnswer) {
      borderColor = Colors.green;
      bgColor = Colors.green.withValues(alpha: 0.1);
      icon = Icons.check_circle;
    } else if (isUserChoice && !isCorrect) {
      borderColor = Colors.red;
      bgColor = Colors.red.withValues(alpha: 0.1);
      icon = Icons.cancel;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCorrectAnswer || isUserChoice ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (icon != null) Icon(icon, color: isCorrectAnswer ? Colors.green : Colors.red),
        ],
      ),
    );
  }
}