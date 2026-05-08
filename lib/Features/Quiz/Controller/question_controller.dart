import 'dart:async';
import 'package:askio/Features/Quiz/Services/groq_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/question_model.dart';
import '../Model/quiz_result_model.dart';
import '../Services/quiz_result_service.dart';

class QuestionController extends GetxController {
  var questions = <QuestionModel>[].obs;
  var currentIndex = 0.obs;
  var userAnswers = <int?>[].obs;
  var isSubmitting = false.obs;

  Timer? _timer;
  var remainingSeconds = 0.obs;

  String? _currentQuizId;
  String? _currentQuizTitle;
  String? _currentUserId;

  void startTimer(
    int durationMinutes, {
    required String quizId,
    required String userId,
    required String quizTitle,
  }) {
    _currentQuizId = quizId;
    _currentUserId = userId;
    _currentQuizTitle = quizTitle;

    _timer?.cancel();
    remainingSeconds.value = durationMinutes * 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
        handleTimeOut();
      }
    });
  }

  String get formattedTime {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void handleTimeOut() async {
    if (isSubmitting.value) return;

    Get.snackbar(
      "Time is Over!",
      "Time is up, your answers are being submitted automatically.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    await submitQuiz(
      quizId: _currentQuizId ?? "",
      quizTitle: _currentQuizTitle ?? "Untitled Quiz",
      userId: _currentUserId ?? "",
    );

    Get.offAllNamed('/home');
  }

  void setQuestions(List<QuestionModel> qList) {
    questions.assignAll(qList);
    userAnswers.assignAll(List.filled(qList.length, null));
    currentIndex.value = 0;
  }

  void inputAnswer(int questionIndex, int answerIndex) {
    userAnswers[questionIndex] = answerIndex;
    userAnswers.refresh();
  }

  void goToQuestion(int index) {
    currentIndex.value = index;
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    }
  }

  void prevQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  bool get allAnswered => !userAnswers.contains(null);

  int calculateScore() {
    if (questions.isEmpty) return 0;

    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (i < userAnswers.length &&
          userAnswers[i] == questions[i].correctAnswerIndex) {
        correct++;
      }
    }
    return ((correct / questions.length) * 100).round();
  }

  Future<void> submitQuiz({
    required String quizId,
    required String quizTitle,
    required String userId,
  }) async {
    try {
      isSubmitting.value = true;
      _timer?.cancel();

      List<Map<String, String>> incorrectListForAI = [];

      for (int i = 0; i < questions.length; i++) {
        var q = questions[i];
        int? selectedAns = i < userAnswers.length ? userAnswers[i] : null;
        bool isCorrect = selectedAns == q.correctAnswerIndex;

        if (!isCorrect && selectedAns != null) {
          incorrectListForAI.add({
            "id": i.toString(),
            "question": q.questionText,
            "userAnswer": q.options[selectedAns],
            "correctAnswer": q.options[q.correctAnswerIndex],
          });
        }
      }

      final groq = GroqService();
      Map<String, String> allFeedback = {};

      if (incorrectListForAI.isNotEmpty) {
        debugPrint("Requesting Batch AI Feedback via Groq for Askio...");
        allFeedback = await groq.getBatchFeedback(
          incorrectQuestions: incorrectListForAI,
        );
        print("All Feedback Map: $allFeedback");
      }

      List<ResultDetailModel> details = [];
      for (int i = 0; i < questions.length; i++) {
        var q = questions[i];
        int? selectedAns = i < userAnswers.length ? userAnswers[i] : null;
        bool isCorrect = selectedAns == q.correctAnswerIndex;

        details.add(
          ResultDetailModel(
            questionText: q.questionText,
            options: q.options,
            selectedAnswerIndex: selectedAns,
            correctAnswerIndex: q.correctAnswerIndex,
            isCorrect: isCorrect,
            selectedAnswerText: selectedAns != null
                ? q.options[selectedAns]
                : "Not answered",
            correctAnswerText: q.options[q.correctAnswerIndex],
            aiFeedback:
                allFeedback[i.toString()] ??
                (isCorrect ? null : "Explanation temporarily unavailable."),
          ),
        );
      }

      await QuizResultService().saveQuiz(
        QuizResultModel(
          userId: userId,
          quizId: quizId,
          quizTitle: quizTitle,
          score: calculateScore(),
          details: details,
        ),
      );

      debugPrint("✅ Submission successful with Groq!");
    } catch (e) {
      debugPrint("❌ ERROR submitQuiz: $e");
      Get.snackbar("Oops!", "Failed to save your answers.");
    } finally {
      isSubmitting.value = false;
    }
  }

  void reset() {
    _timer?.cancel();
    questions.clear();
    userAnswers.clear();
    currentIndex.value = 0;
    remainingSeconds.value = 0;
    isSubmitting.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
