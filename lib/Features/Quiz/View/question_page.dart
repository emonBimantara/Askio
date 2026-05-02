import 'package:askio/Widgets/answer_bar.dart';
import 'package:askio/Components/custom_button.dart';
import 'package:askio/Widgets/question_number_bar.dart';
import 'package:askio/Features/Auth/Controller/auth_controller.dart';
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
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final QuestionController controller = Get.put(QuestionController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          controller.reset(); 
        }
      },
      child: Scaffold(
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

              if (controller.questions.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.setQuestions(snapshot.data!);
                });
              }

              return Obx(() {
                if (controller.questions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final questions = controller.questions;
                final currentIndex = controller.currentIndex.value;
                final currentQuestion = questions[currentIndex];
                final isLastQuestion = currentIndex == questions.length - 1;
                final selectedAnswer = controller.userAnswers[currentIndex];

                return Stack(
                  children: [
                    
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                "Question ${currentIndex + 1}/${questions.length}",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                QuestionNumberBar(),
                                const SizedBox(height: 20),
                                Text(
                                  currentQuestion.questionText,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                                ),
                                const SizedBox(height: 25),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: currentQuestion.options.length,
                                    itemBuilder: (context, index) {
                                      final isSelected = selectedAnswer == index;
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
                                  customText: controller.isSubmitting.value 
                                      ? "Submitting..." 
                                      : (isLastQuestion ? "Finish Quiz" : "Next Question"),
                                  
                                  onTap: controller.isSubmitting.value ? null : () async {
                                    if (!isLastQuestion) {
                                      controller.nextQuestion();
                                    } else {
                                      if (!controller.allAnswered) {
                                        Get.snackbar("Warning", "Fill all the questions before submitting.");
                                        return;
                                      }

                                      Get.defaultDialog(
                                        title: "Submit Quiz",
                                        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                                        middleText: "Are you sure you want to finish and submit this quiz? You cannot change your answers afterward.",
                                        textConfirm: "Yes, Submit",
                                        textCancel: "Cancel",
                                        confirmTextColor: Colors.white,
                                        buttonColor: const Color(0xFF2120FF),
                                        cancelTextColor: const Color(0xFF2120FF),
                                        radius: 15,
                                        
                                        onConfirm: () async {
                                          Get.back(); 

                                          controller.isSubmitting.value = true;

                                          final finalScore = controller.calculateScore();

                                          await controller.submitQuiz(
                                            quizId: quiz.id,
                                            userId: authController.user!.uid,
                                            quizTitle: quiz.title,
                                          );

                                          Get.snackbar("Quiz Finished", "Your score: $finalScore");
                                          Get.offAllNamed('/home');
                                          
                                          controller.reset(); 
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (controller.isSubmitting.value)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(height: 20),
                                Text(
                                  "Submitting your answers...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ), 
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                  ],
                );
              });
            },
          ),
        ),
      ),
    );
  }
}