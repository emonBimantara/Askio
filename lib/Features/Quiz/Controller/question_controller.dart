import 'package:get/get.dart';
import '../Model/question_model.dart';
import '../Model/quiz_result_model.dart';
import '../Services/quiz_result_service.dart';

class QuestionController extends GetxController {
  var questions = <QuestionModel>[].obs;
  var currentIndex = 0.obs;
  var userAnswers = <int?>[].obs;

  var isSubmitting = false.obs;

  void setQuestions(List<QuestionModel> qList) {
    questions.value = qList;
    userAnswers.value = List.filled(qList.length, null);
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

  bool get allAnswered {
    return userAnswers.every((ans) => ans != null);
  }

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
      List<ResultDetailModel> details = questions.asMap().entries.map((entry) {
        int index = entry.key;
        var q = entry.value;
        int? selectedAns = index < userAnswers.length
            ? userAnswers[index]
            : null;

        return ResultDetailModel(
          questionText: q.questionText,
          options: q.options,
          selectedAnswerIndex: selectedAns,
          correctAnswerIndex: q.correctAnswerIndex,
          isCorrect: selectedAns == q.correctAnswerIndex,
        );
      }).toList();

      QuizResultModel finalResult = QuizResultModel(
        userId: userId,
        quizId: quizId,
        quizTitle: quizTitle,
        score: calculateScore(),
        details: details,
      );

      await QuizResultService().saveQuiz(finalResult);
    } catch (e) {
      print("ERROR submitQuiz: $e");
    }
  }

  void reset() {
    questions.clear();
    userAnswers.clear();
    currentIndex.value = 0;
  }
}
