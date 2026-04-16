import 'package:askio/Components/answer_bar.dart';
import 'package:askio/Components/custom_button.dart';
import 'package:askio/Components/question_number_bar.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Quiz/Controller/question_controller.dart';
import 'package:askio/Features/Quiz/Model/question_model.dart';
import 'package:askio/Features/Quiz/Services/question_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionPage extends StatelessWidget {
  final QuizModel quiz;

  QuestionPage({super.key, required this.quiz});

  final QuestionService questionService = QuestionService();
  final QuestionController controller = Get.put(
    QuestionController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<QuestionModel>>(
          future: questionService.getQuestions(quiz.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Questions Found"));
            }

            controller.setQuestions(snapshot.data!);

            return Obx(() {
              final questions = controller.questions;
              final currentIndex = controller.currentIndex.value;
              final currentQuestion = questions[currentIndex];
              final isLastQuestion = currentIndex == questions.length - 1;

              final selectedAnswer = controller.userAnswers[currentIndex];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Question ${currentIndex + 1}/${questions.length}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
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
                          QuestionNumberBar(),
                          SizedBox(height: 20),
                          Text(
                            currentQuestion.questionText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 25),

                          Expanded(
                            child: ListView.builder(
                              itemCount: currentQuestion.options.length,
                              itemBuilder: (context, index) {
                                final isSelected =
                                    controller.userAnswers[currentIndex] ==
                                    index;

                                return AnswerBar(
                                  text: currentQuestion.options[index],
                                  isSelected: isSelected,
                                  onTap: () {
                                    controller.inputAnswer(currentIndex, index);
                                  },
                                );
                              },
                            ),
                          ),

                          CustomButton(
                            customText: isLastQuestion
                                ? "Finish Quiz"
                                : "Next Question",
                            onTap: () {
                              if (selectedAnswer == null) {
                                Get.snackbar(
                                  "Warning",
                                  "Please select an answer first",
                                );
                                return;
                              }

                              if (!isLastQuestion) {
                                controller.nextQuestion();
                              } else {
                                if (!controller.allAnswered) {
                                  Get.snackbar(
                                    "Warning",
                                    "Masih ada soal yang belum dijawab",
                                  );
                                  return;
                                }

                                final score = controller.calculateScore();

                                Get.snackbar("Quiz Finished", "Score: $score");

                                // TODO: navigate ke result page
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
