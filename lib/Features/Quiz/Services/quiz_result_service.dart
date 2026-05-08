import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Model/quiz_result_model.dart';

class QuizResultService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> saveQuiz(QuizResultModel result) async {
    try {
      String uniqueDocId = "${result.userId}_${result.quizId}";

      await db.collection('user_results').add(result.toMap());
    } catch (e) {
      print("ERROR saveQuiz: $e");
    }
  }

  Future<List<QuizResultModel>> getQuizResult(String userId) async {
    try {
      final snapshot = await db
          .collection('user_results')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return QuizResultModel.fromFireStore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print("ERROR getQuizResult: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllParticipantResults(
    String quizId,
  ) async {
    try {
      final snapshot = await db
          .collection('user_results')
          .where('quizId', isEqualTo: quizId)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("❌ Error fetching all results: $e");
      return [];
    }
  }

  Map<String, int> analyzeWeakPoints(List<Map<String, dynamic>> allResults) {
    Map<String, int> failureCount = {};

    for (var result in allResults) {
      List details = result['details'] ?? [];
      for (var item in details) {
        if (item['isCorrect'] == false) {
          String question = item['questionText'] ?? "Unknown Question";
          failureCount[question] = (failureCount[question] ?? 0) + 1;
        }
      }
    }

    var sortedEntries = failureCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }
}
