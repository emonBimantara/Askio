import 'package:askio/Components/custom_button.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Home/Controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class QuizPreviewPage extends StatelessWidget {
  final QuizModel quiz;

  QuizPreviewPage({super.key, required this.quiz});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final bool isTeacher = homeController.userRole.value == 'teacher';

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Row(
              children: [
                const BackButton(),
                const SizedBox(width: 10),
                const Text('Quiz Detail', style: TextStyle(fontSize: 20)),
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
                  const SizedBox(height: 10),

                  if (isTeacher) ...[
                    const Text(
                      'Share this code with your students:',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2120FF).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF2120FF).withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "QUIZ CODE",
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                    color: Color(0xFF2120FF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  quiz.quizCode,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 4,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: quiz.quizCode),
                              );
                              Get.snackbar(
                                "Copied!",
                                "Quiz code copied to clipboard",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xFF2120FF),
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(15),
                                duration: const Duration(seconds: 2),
                              );
                            },
                            icon: const Icon(
                              Icons.copy_rounded,
                              color: Color(0xFF2120FF),
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: Colors.black12,
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Divider(thickness: 1, color: Color(0xFFE8ECF4)),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Participants List',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2120FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${quiz.participants.length} Joined",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Expanded(
                      child: quiz.participants.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.group_off_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "No students have joined yet.",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: quiz.participants.length,
                              padding: const EdgeInsets.only(top: 5),
                              itemBuilder: (context, index) {
                                final participant = quiz.participants[index];

                                String participantName = "Unknown Student";
                                if (participant is Map) {
                                  participantName =
                                      participant['name'] ?? "Unknown";
                                } else {
                                  participantName = participant.toString();
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Color(0xFF2120FF),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Text(
                                          participantName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ] else ...[
                    const Text(
                      'Please read the text below carefully so you can understand it',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),

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
                    }),

                    const Spacer(),
                    CustomButton(
                      onTap: () => {
                        Get.toNamed('/questionPage', arguments: quiz),
                      },
                      customText: 'Start Quiz',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
