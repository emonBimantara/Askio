import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:flutter/material.dart';

class QuizPreviewPage extends StatelessWidget {
  final QuizModel quiz;

  const QuizPreviewPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Row(
              children: [
                BackButton(),
                SizedBox(width: 10),
                Text('Quiz Detail', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Please read the text below carefully so you can understand it',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  
                  SizedBox(height: 25),
                  
                  ...quiz.rules.map((rule) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text("• $rule"),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
