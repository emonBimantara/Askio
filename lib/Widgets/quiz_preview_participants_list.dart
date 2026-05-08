import 'package:askio/Features/Home/Services/quiz_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizPreviewParticipantsList extends StatelessWidget {
  final List<dynamic> participants;
  final String quizId;

  const QuizPreviewParticipantsList({
    super.key,
    required this.participants,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: participants.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final p = participants[index];

        return InkWell(
          onTap: () => _showStatsModal(p['uid'], p['name']),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(child: Text(p['name'][0])),
                const SizedBox(width: 15),
                Text(
                  p['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStatsModal(String userId, String userName) async {
    final quizService = QuizService();

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final attempts = await quizService.getParticipantAttempts(quizId, userId);

    Get.back();

    if (attempts.isEmpty) {
      Get.snackbar("Info", "$userName belum menyelesaikan kuis ini.");
      return;
    }

    int totalAttempts = attempts.length;
    int firstScore = attempts.first['score'] ?? 0;
    int bestScore = attempts
        .map((a) => (a['score'] as num).toInt())
        .reduce((a, b) => a > b ? a : b);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Student Quiz Statistics",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Divider(),
            _buildStatRow("Total Attempts", "$totalAttempts", Colors.black),
            _buildStatRow("First Score", "$firstScore", Colors.blue),
            _buildStatRow("Best Score", "$bestScore", Colors.green),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
