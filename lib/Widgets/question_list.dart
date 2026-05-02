import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:askio/Features/Home/Controller/add_quiz_controller.dart';
import 'option_rows.dart';

class QuestionList extends StatelessWidget {
  final AddQuizController controller;

  const QuestionList({super.key, required this.controller});

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

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2120FF), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: List.generate(controller.questions.length, (index) {
          final q = controller.questions[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Question ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF2120FF),
                      ),
                    ),
                    if (controller.questions.length > 1)
                      InkWell(
                        onTap: () => controller.removeQuestion(index),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),

                const Divider(height: 30),

                const Text(
                  "Quiz Question",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: q['questionText'],
                  decoration: _customInputDecoration(
                    "Enter your question here...",
                  ),
                ),

                const SizedBox(height: 20),

                OptionRows(q: q),

                const SizedBox(height: 20),

                const Text(
                  "Correct Answer",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  initialValue: q['correctAnswer'],
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  decoration: _customInputDecoration("Select correct answer")
                      .copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),

                  items: ['A', 'B', 'C', 'D'].map((val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Row(
                        children: [
                          Text(
                            "Option $val",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  onChanged: (val) {
                    q['correctAnswer'] = val!;
                    controller.questions.refresh(); 
                  },
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
