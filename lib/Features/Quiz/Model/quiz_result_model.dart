import 'package:cloud_firestore/cloud_firestore.dart';

class QuizResultModel {
  final String? id;
  final String userId;
  final String quizTitle;
  final String quizId;
  final int score;
  final DateTime? createdAt;
  final List<ResultDetailModel> details;
  final String? aiFeedback;

  QuizResultModel({
    this.id,
    required this.userId,
    required this.quizTitle,
    required this.quizId,
    required this.score,
    this.createdAt,
    required this.details,
    this.aiFeedback,
  });

  List<Map<String, String>> toGeminiPayload() {
    return details.where((detail) => !detail.isCorrect).map((detail) {
      String userText =
          (detail.selectedAnswerIndex != null &&
              detail.selectedAnswerIndex! < detail.options.length)
          ? detail.options[detail.selectedAnswerIndex!]
          : "Not answered";

      String correctText = detail.options[detail.correctAnswerIndex];

      return {
        "question": detail.questionText,
        "user_answer": userText,
        "correct_answer": correctText,
      };
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "quizTitle": quizTitle,
      "quizId": quizId,
      "score": score,
      "createdAt": FieldValue.serverTimestamp(),
      "details": details.map((e) => e.toMap()).toList(),
      "aiFeedback": aiFeedback,
    };
  }

  factory QuizResultModel.fromFireStore(String id, Map<String, dynamic> data) {
    return QuizResultModel(
      id: id,
      userId: data['userId'] ?? '',
      quizTitle: data['quizTitle'] ?? '',
      quizId: data['quizId'] ?? '',
      score: data['score'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      details: (data['details'] as List? ?? [])
          .map((e) => ResultDetailModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      aiFeedback: data['aiFeedback'] ?? '',
    );
  }
}

class ResultDetailModel {
  final String questionText;
  final List<String> options;
  final int? selectedAnswerIndex;
  final int correctAnswerIndex;
  final bool isCorrect;
  final String? selectedAnswerText;
  final String correctAnswerText;
  final String? aiFeedback;

  ResultDetailModel({
    required this.questionText,
    required this.options,
    required this.selectedAnswerIndex,
    required this.correctAnswerIndex,
    required this.isCorrect,
    this.selectedAnswerText,
    required this.correctAnswerText,
    this.aiFeedback,
  });

  Map<String, dynamic> toMap() {
    return {
      "questionText": questionText,
      "options": options,
      "selectedAnswerIndex": selectedAnswerIndex,
      "correctAnswerIndex": correctAnswerIndex,
      "isCorrect": isCorrect,
      "selectedAnswerText": selectedAnswerText,
      "correctAnswerText": correctAnswerText,
      "aiFeedback": aiFeedback,
    };
  }

  factory ResultDetailModel.fromMap(Map<String, dynamic> map) {
    return ResultDetailModel(
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      selectedAnswerIndex: map['selectedAnswerIndex'],
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      isCorrect: map['isCorrect'] ?? false,
      selectedAnswerText: map['selectedAnswerText'],
      correctAnswerText: map['correctAnswerText'] ?? '',
      aiFeedback: map['aiFeedback'] ?? '',
    );
  }
}
