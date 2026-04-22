import 'package:askio/Features/Home/Controller/history_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryView extends StatelessWidget {
  HistoryView({super.key});

  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Text(
                'Quiz History',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF2120FF)));
                }

                if (controller.historyList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2120FF).withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.history_edu, size: 60, color: Color(0xFF2120FF)),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No History Yet",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Let's take your first quiz and test your knowledge!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => controller.fetchHistory(),
                  color: const Color(0xFF2120FF),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: controller.historyList.length,
                    itemBuilder: (context, index) {
                      final historyData = controller.historyList[index];
                      
                      final String quizTitle = historyData['quizTitle'] ?? "Unknown Quiz";
                      final List details = historyData['details'] ?? [];
                      final int totalQuestions = details.length;
                      final int correctAnswers = details.where((d) => d['isCorrect'] == true).length;
                      
                      final Timestamp? createdAt = historyData['createdAt'];
                      final String dateStr = createdAt != null 
                          ? "${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}" 
                          : "Unknown Date";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2120FF).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.assignment_turned_in, 
                                color: Color(0xFF2120FF),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quizTitle,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Date: $dateStr",
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Score",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      "$correctAnswers",
                                      style: const TextStyle(
                                        color: Color(0xFF2120FF), 
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "/$totalQuestions",
                                      style: TextStyle(
                                        color: Colors.grey.shade400, 
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}