import 'package:askio/Components/custom_button.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Quiz/Model/question_model.dart';
import 'package:askio/Features/Quiz/Services/question_service.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  final QuizModel quiz;
  const QuestionPage({super.key, required this.quiz});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final QuestionService questionService = QuestionService();
  int currentIndex = 0;
  late Future<List<QuestionModel>> questionList;

  @override
  void initState() {
    super.initState();
    questionList = questionService.getQuestions(widget.quiz.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<QuestionModel>>(
          future: questionList,
          builder: (context, snapshot) {
            // 🔹 LOADING
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 🔹 ERROR
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // 🔹 EMPTY
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Questions Found"));
            }

            final questions = snapshot.data!;
            final currentQuestion = questions[currentIndex];
            final isLastQuestion =
                currentIndex == questions.length - 1;

            return Column(
              children: [
                // 🔹 HEADER
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const BackButton(),
                      const SizedBox(width: 10),
                      Text(
                        "Question ${currentIndex + 1}/${questions.length}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 CONTENT
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
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
                        // 🔹 QUESTION TEXT
                        Text(
                          currentQuestion.questionText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // 🔹 OPTIONS
                        Expanded(
                          child: ListView.builder(
                            itemCount: currentQuestion.options.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        currentQuestion.options[index],
                                        style: const TextStyle(
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // 🔹 BUTTON
                        CustomButton(
                          customText:
                              isLastQuestion ? "Finish Quiz" : "Next Question",
                          onTap: () {
                            if (!isLastQuestion) {
                              setState(() {
                                currentIndex++;
                              });
                            } else {
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}