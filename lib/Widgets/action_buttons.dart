import 'package:flutter/material.dart';
import 'package:askio/Features/Home/Controller/add_quiz_controller.dart'; 

class ActionButtons extends StatelessWidget {
  final AddQuizController controller;

  const ActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: controller.addNewQuestion,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text("Add Another Question", style: TextStyle(fontSize: 16)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2120FF),
            side: const BorderSide(color: Color(0xFF2120FF)),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: controller.saveQuiz,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2120FF),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "Save & Upload Quiz",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}