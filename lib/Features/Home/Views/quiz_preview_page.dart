import 'package:askio/Components/custom_button.dart';
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

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${quiz.totalQuestions} Questions",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  "${quiz.duration} Min",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
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
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "• ",
                              style: TextStyle(fontSize: 16),
                            ),
                            TextSpan(
                              text: rule.replaceAll('\n', ' '),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  Spacer(),
                  CustomButton(
                    onTap: () => (){},
                    customText: 'Start Quiz')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
