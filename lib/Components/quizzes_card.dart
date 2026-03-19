import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:flutter/material.dart';

class QuizzesCard extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onTap;

  const QuizzesCard({super.key, required this.quiz, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFEEF2FF),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calculate, color: Color(0xFF2120FF), size: 30),
            ),

            SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${quiz.totalQuestions} Questions',
                        style: TextStyle(color: Colors.grey),
                      ),

                      SizedBox(width: 15),

                      Icon(Icons.timer_outlined, size: 18, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        '${quiz.duration} Min',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
