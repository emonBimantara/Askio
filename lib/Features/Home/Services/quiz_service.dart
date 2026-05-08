import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/quiz_model.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<QuizModel>> getQuizzes({
    String? teacherId,
    String? studentId,
  }) async {
    try {
      Query query = _db.collection('quizzes');

      if (teacherId != null) {
        query = query.where('teacherId', isEqualTo: teacherId);
      } else if (studentId != null) {
        query = query.where('participantIds', arrayContains: studentId);
      } else {
        return [];
      }

      query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        return QuizModel.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      print("Error fetching quizzes: $e");
      return [];
    }
  }

  Future<bool> joinQuizByCode(
    String quizCode,
    String studentId,
    String studentName,
  ) async {
    try {
      final snapshot = await _db
          .collection('quizzes')
          .where('quizCode', isEqualTo: quizCode)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        Get.snackbar("Error", "Quiz code not found");
        return false;
      }

      final quizDoc = snapshot.docs.first;
      final List participants = quizDoc.data()['participants'] ?? [];

      bool isAlreadyJoined = participants.any((p) {
        if (p is Map) return p['uid'] == studentId;
        return p == studentId;
      });

      if (isAlreadyJoined) {
        Get.snackbar("Info", "You have already joined this quiz");
        return false;
      }

      await _db.collection('quizzes').doc(quizDoc.id).update({
        'participants': FieldValue.arrayUnion([
          {'uid': studentId, 'name': studentName},
        ]),
        'participantIds': FieldValue.arrayUnion([studentId]),
      });

      return true;
    } catch (e) {
      print("Error joining quiz: $e");
      return false;
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    await _db.collection('quizzes').doc(quizId).delete();
  }

  Future<List<Map<String, dynamic>>> getQuizHistory(String userId) async {
    try {
      final snapshot = await _db
          .collection('user_results')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching quiz history: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getParticipantAttempts(
    String quizId,
    String userId,
  ) async {
    try {
      final snapshot = await _db
          .collection('user_results')
          .where('quizId', isEqualTo: quizId)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Error fetching attempts: $e");
      return [];
    }
  }
}

class UserService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> getUserRole(String uid) async {
    try {
      final doc = await db.collection('users').doc(uid).get();
      return doc.exists ? (doc.data()?['role'] ?? 'student') : 'student';
    } catch (e) {
      return 'student';
    }
  }
}

class AddQuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _generateQuizCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    return List.generate(
      6,
      (index) => chars[Random().nextInt(chars.length)],
    ).join();
  }

  Future<void> uploadQuiz({
    required String title,
    required int duration,
    required List<String> rules,
    required String teacherId,
    required List<Map<String, dynamic>> questions,
  }) async {
    final batch = _db.batch();
    final quizRef = _db.collection('quizzes').doc();
    final String quizCode = _generateQuizCode();

    batch.set(quizRef, {
      'title': title,
      'duration': duration,
      'rules': rules,
      'teacherId': teacherId,
      'quizCode': quizCode,
      'totalQuestions': questions.length,
      'participants': [],
      'participantIds': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    Map<String, int> answerMap = {'A': 0, 'B': 1, 'C': 2, 'D': 3};

    for (var q in questions) {
      final questionRef = quizRef.collection('questions').doc();

      List<String> options = [
        q['optionA'].text,
        q['optionB'].text,
        q['optionC'].text,
        q['optionD'].text,
      ];

      int correctIndex = answerMap[q['correctAnswer']] ?? 0;

      batch.set(questionRef, {
        'questionText': q['questionText'].text,
        'options': options,
        'correctAnswerIndex': correctIndex,
      });
    }

    await batch.commit();
  }
}
