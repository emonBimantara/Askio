import 'package:get/get.dart';

class HistoryDetailController extends GetxController {
  var currentIndex = 0.obs;

  void goToQuestion(int index) => currentIndex.value = index;
  void nextQuestion(int total) {
    if (currentIndex.value < total - 1) currentIndex.value++;
  }
}
