import 'package:flutter/material.dart';
import 'package:askio/Features/Home/Controller/add_quiz_controller.dart'; 

class QuizInfoCard extends StatelessWidget {
  final AddQuizController controller;

  const QuizInfoCard({super.key, required this.controller});

  InputDecoration _customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quiz Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.titleController,
          decoration: _customInputDecoration("e.g., Saturday Night Quiz"),
        ),
        
        const SizedBox(height: 20),
        
        const Text("Duration (Minutes)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.durationController,
          keyboardType: TextInputType.number,
          decoration: _customInputDecoration("e.g., 15"),
        ),
        
        const SizedBox(height: 20),
        
        const Text("Quiz Rules", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.rulesController,
          maxLines: 3,
          decoration: _customInputDecoration("(Type with comma)"),
        ),
      ],
    );
  }
}