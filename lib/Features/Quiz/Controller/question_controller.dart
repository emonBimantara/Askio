import 'package:get/get.dart';
import '../Model/question_model.dart';

class QuestionController extends GetxController {
  var questions = <QuestionModel>[].obs;

  var currentIndex = 0.obs;

  var userAnswers = <int?>[].obs;

  var isInitialized = false;

  void setQuestions(List<QuestionModel> qList) {
    if (isInitialized) return;

    questions.value = qList;
    userAnswers.value = List.filled(qList.length, null);
    isInitialized = true;
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
    int correct = 0;

    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctAnswerIndex) {
        correct++;
      }
    }

    return ((correct / questions.length) * 100).round();
  }

  void reset() {
    userAnswers.clear();
    currentIndex.value = 0;
    isInitialized = false;
  }
}
