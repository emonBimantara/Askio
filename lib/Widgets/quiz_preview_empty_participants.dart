import 'package:flutter/material.dart';

class QuizPreviewEmptyParticipants extends StatelessWidget {
  const QuizPreviewEmptyParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off_outlined, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No students have joined yet.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}