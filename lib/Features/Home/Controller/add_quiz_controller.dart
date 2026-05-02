import 'package:askio/Features/Home/Controller/home_controller.dart';
import 'package:askio/Features/Home/Services/quiz_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddQuizController extends GetxController {
  final AddQuizService _service = AddQuizService();

  final titleController = TextEditingController();
  final durationController = TextEditingController();
  final rulesController = TextEditingController();

  var questions = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    addNewQuestion();
  }

  void addNewQuestion() {
    questions.add({
      'questionText': TextEditingController(),
      'optionA': TextEditingController(),
      'optionB': TextEditingController(),
      'optionC': TextEditingController(),
      'optionD': TextEditingController(),
      'correctAnswer': 'A',
    });
  }

  void removeQuestion(int index) {
    questions.removeAt(index);
  }

  Future<void> saveQuiz() async {
    if (titleController.text.isEmpty || durationController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in the title and duration first.");
      return;
    }

    try {
      isLoading(true);
      final teacherId = FirebaseAuth.instance.currentUser!.uid;

      List<String> rulesList = rulesController.text.isNotEmpty
          ? rulesController.text.split(',').map((e) => e.trim()).toList()
          : ["Read each question carefully before answering."];

      await _service.uploadQuiz(
        title: titleController.text,
        duration: int.parse(durationController.text),
        rules: rulesList,
        teacherId: teacherId,
        questions: questions,
      );

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().refreshQuizzes();
      }

      Get.back();
      Get.snackbar(
        "Success",
        "Quiz uploaded successfully! Share the code with your students.",
      );
    } catch (e) {
      Get.snackbar("Error", "Upload failed: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    durationController.dispose();
    rulesController.dispose();

    for (var q in questions) {
      (q['questionText'] as TextEditingController).dispose();
      (q['optionA'] as TextEditingController).dispose();
      (q['optionB'] as TextEditingController).dispose();
      (q['optionC'] as TextEditingController).dispose();
      (q['optionD'] as TextEditingController).dispose();
    }

    super.onClose();
  }
}
