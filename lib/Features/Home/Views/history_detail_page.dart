import 'package:askio/Components/custom_button.dart';
import 'package:askio/Features/Quiz/Model/quiz_result_model.dart';
import 'package:askio/Widgets/history_question_number_bar.dart';
import 'package:askio/Widgets/review_answer_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/history_detail_controller.dart';

class HistoryDetailPage extends StatelessWidget {
  final QuizResultModel result;
  const HistoryDetailPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryDetailController(), tag: result.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE2), 
      body: SafeArea(
        child: Obx(() {
          final currentIndex = controller.currentIndex.value;
          final currentDetail = result.details[currentIndex];
          final isLastQuestion = currentIndex == result.details.length - 1;

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Review ${currentIndex + 1}/${result.details.length}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2120FF).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.stars, size: 18, color: Color(0xFF2120FF)),
                              const SizedBox(width: 5),
                              Text(
                                "Score: ${result.score}",
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2120FF)),
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
                          HistoryQuestionNumberBar(details: result.details, tag: result.id!),
                          
                          const SizedBox(height: 25),
                          
                          Text(
                            currentDetail.questionText,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          
                          const SizedBox(height: 25),
                          
                          Expanded(
                            child: ListView.builder(
                              itemCount: currentDetail.options.length,
                              itemBuilder: (context, index) {
                                return ReviewAnswerBar(
                                  text: currentDetail.options[index],
                                  isCorrectAnswer: index == currentDetail.correctAnswerIndex,
                                  isUserChoice: index == currentDetail.selectedAnswerIndex,
                                  isCorrect: currentDetail.isCorrect,
                                );
                              },
                            ),
                          ),

                          CustomButton(
                            customText: isLastQuestion ? "Back to History" : "Next Question",
                            onTap: () {
                              if (isLastQuestion) {
                                Get.back();
                              } else {
                                controller.nextQuestion(result.details.length);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}