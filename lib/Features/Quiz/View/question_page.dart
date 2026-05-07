import 'package:askio/Widgets/answer_bar.dart';
import 'package:askio/Components/custom_button.dart';
import 'package:askio/Widgets/question_number_bar.dart';
import 'package:askio/Features/Auth/Controller/auth_controller.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Quiz/Controller/question_controller.dart';
import 'package:askio/Features/Quiz/Model/question_model.dart';
import 'package:askio/Features/Quiz/Services/question_service.dart';
import 'package:askio/Widgets/submit_dialog.dart';
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
      onPopInvokedWithResult: (didPop, result) {},
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
                  controller.startTimer(
                    quiz.duration,
                    quizId: quiz.id,
                    userId: authController.user!.uid,
                    quizTitle: quiz.title,
                  );
                });
              }

              return Obx(() {
                if (controller.questions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final currentIndex = controller.currentIndex.value;
                final currentQuestion = controller.questions[currentIndex];
                final isLastQuestion =
                    currentIndex == controller.questions.length - 1;

                return Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Question ${currentIndex + 1}/${controller.questions.length}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.remainingSeconds.value < 60
                                      ? Colors.red.withValues(alpha: 0.1)
                                      : const Color(
                                          0xFF2120FF,
                                        ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      size: 18,
                                      color:
                                          controller.remainingSeconds.value < 60
                                          ? Colors.red
                                          : const Color(0xFF2120FF),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      controller.formattedTime,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            controller.remainingSeconds.value <
                                                60
                                            ? Colors.red
                                            : const Color(0xFF2120FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                top: Radius.circular(35),
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
                                const SizedBox(height: 25),
                                Text(
                                  currentQuestion.questionText,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: currentQuestion.options.length,
                                    itemBuilder: (context, index) {
                                      return AnswerBar(
                                        text: currentQuestion.options[index],
                                        isSelected:
                                            controller
                                                .userAnswers[currentIndex] ==
                                            index,
                                        onTap: () => controller.inputAnswer(
                                          currentIndex,
                                          index,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                CustomButton(
                                  customText: controller.isSubmitting.value
                                      ? "Submitting..."
                                      : (isLastQuestion
                                            ? "Finish Quiz"
                                            : "Next Question"),
                                  onTap: controller.isSubmitting.value
                                      ? null
                                      : () async {
                                          if (!isLastQuestion) {
                                            controller.nextQuestion();
                                          } else {
                                            showSubmitDialog(
                                              controller: controller,
                                              quizId: quiz.id,
                                              quizTitle: quiz.title,
                                              userId: authController.user!.uid,
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
                      Container(
                        color: Colors.black.withValues(alpha: 0.6),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 20),
                              Text(
                                "Calculating your results...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
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
      ),
    );
  }
}
