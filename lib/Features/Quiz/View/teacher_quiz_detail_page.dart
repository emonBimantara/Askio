import 'package:askio/Components/custom_button.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Quiz/Controller/teacher_quiz_detail_controller.dart';
import 'package:askio/Features/Quiz/Services/question_service.dart';
import 'package:askio/Features/Quiz/Model/question_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherQuizDetailPage extends StatelessWidget {
  final QuizModel quiz;
  TeacherQuizDetailPage({super.key, required this.quiz});

  final QuestionService questionService = QuestionService();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherQuizController());

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<QuestionModel>>(
          future: questionService.getQuestions(quiz.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF2120FF)));
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Questions Found"));
            }

            final questions = snapshot.data!;

            return Obx(() {
              final currentIndex = controller.currentIndex.value;
              final currentQuestion = questions[currentIndex];
              final isLast = currentIndex == questions.length - 1;

              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackButton(),
                        Text(
                          "Preview ${currentIndex + 1}/${questions.length}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.fact_check_outlined, color: Color(0xFF2120FF)),
                      ],
                    ),
                  ),

                  // Container Putih
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Progress Indikator (Nomor Soal)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(questions.length, (index) {
                                return GestureDetector(
                                  onTap: () => controller.goToQuestion(index),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    margin: const EdgeInsets.only(right: 8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentIndex == index ? Colors.black : Colors.grey[200],
                                    ),
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: currentIndex == index ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          
                          const SizedBox(height: 25),
                          
                          Text(
                            currentQuestion.questionText,
                            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, height: 1.4),
                          ),
                          
                          const SizedBox(height: 25),
                          
                          Expanded(
                            child: ListView.builder(
                              itemCount: currentQuestion.options.length,
                              itemBuilder: (context, index) {
                                bool isCorrect = index == currentQuestion.correctAnswerIndex;
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: isCorrect ? Colors.green : Colors.grey.shade200,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          currentQuestion.options[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (isCorrect) const Icon(Icons.check_circle, color: Colors.green),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          CustomButton(
                            customText: isLast ? "Finish Review" : "Next Question",
                            onTap: () {
                              if (isLast) {
                                Get.back();
                              } else {
                                controller.nextQuestion(questions.length);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}