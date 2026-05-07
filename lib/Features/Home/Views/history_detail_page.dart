import 'package:askio/Components/custom_button.dart';
import 'package:askio/Features/Quiz/Model/quiz_result_model.dart';
import 'package:askio/Widgets/history_question_number_bar.dart';
import 'package:askio/Widgets/review_answer_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/history_detail_controller.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class HistoryDetailPage extends StatelessWidget {
  final QuizResultModel result;
  const HistoryDetailPage({super.key, required this.result});

  void _showAIFeedback(BuildContext context, String feedbackText) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 20,
                left: 25,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2120FF).withValues(alpha: 0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2120FF).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF2120FF),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text(
                          "Gemini Tutor AI",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(25),
                child: MarkdownBody(
                  data: feedbackText,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                    strong: const TextStyle(fontWeight: FontWeight.bold),
                    listBullet: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

          final showAIBtn =
              !currentDetail.isCorrect && currentDetail.aiFeedback != null;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      "Question ${currentIndex + 1}/${result.details.length}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2120FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Score: ${result.score}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2120FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 20,
                    right: 20,
                    bottom: 20,
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
                      HistoryQuestionNumberBar(
                        details: result.details,
                        tag: result.id!,
                      ),
                      const SizedBox(height: 25),

                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentDetail.questionText,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 25),

                              ...currentDetail.options.asMap().entries.map((
                                entry,
                              ) {
                                int index = entry.key;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ReviewAnswerBar(
                                    text: entry.value,
                                    isCorrectAnswer:
                                        index ==
                                        currentDetail.correctAnswerIndex,
                                    isUserChoice:
                                        index ==
                                        currentDetail.selectedAnswerIndex,
                                    isCorrect: currentDetail.isCorrect,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (showAIBtn) ...[
                        InkWell(
                          onTap: () => _showAIFeedback(
                            context,
                            currentDetail.aiFeedback!,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2120FF,
                              ).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(
                                  0xFF2120FF,
                                ).withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Color(0xFF2120FF),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Explain My Mistake",
                                  style: TextStyle(
                                    color: Color(0xFF2120FF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      CustomButton(
                        customText: isLastQuestion
                            ? "Back to History"
                            : "Next Question",
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
          );
        }),
      ),
    );
  }
}
