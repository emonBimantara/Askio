import 'package:askio/Components/custom_button.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Home/Controller/home_controller.dart';
import 'package:askio/Widgets/quiz_preview_empty_participants.dart';
import 'package:askio/Widgets/quiz_preview_participants_list.dart';
import 'package:askio/Widgets/quiz_rule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class QuizPreviewPage extends StatelessWidget {
  final QuizModel quiz;
  QuizPreviewPage({super.key, required this.quiz});

  final HomeController homeController = Get.find<HomeController>();
  final isCopied = false.obs;

  @override
  Widget build(BuildContext context) {
    final bool isTeacher = homeController.userRole.value == 'teacher';

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE2),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildAppBar(),
          _buildQuizHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: _containerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isTeacher) _buildTeacherContent() else _buildStudentContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Row(
        children: [
          const BackButton(),
          const SizedBox(width: 10),
          const Text('Quiz Detail', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuizHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quiz.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("${quiz.totalQuestions} Questions", style: const TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
          Text("${quiz.duration} Min", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildTeacherContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Share this code with your students:', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 10),
          _buildQuizCodeCard(),
          const SizedBox(height: 25),
          const Divider(thickness: 1, color: Color(0xFFE8ECF4)),
          const SizedBox(height: 15),
          _buildParticipantsHeader(),
          const SizedBox(height: 15),
          Expanded(
            child: quiz.participants.isEmpty
                ? const QuizPreviewEmptyParticipants()
                : QuizPreviewParticipantsList(participants: quiz.participants),
          ),
          const SizedBox(height: 15),
          CustomButton(
            onTap: () => Get.toNamed('/teacherQuizDetail', arguments: quiz),
            customText: 'View Question Details',
          ),
        ],
      ),
    );
  }

  Widget _buildStudentContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Please read the rules carefully:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 25),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: quiz.rules.map((rule) => QuizRuleItem(rule: rule)).toList(),
            ),
          ),
          const SizedBox(height: 15),
          CustomButton(
            onTap: () => Get.toNamed('/questionPage', arguments: quiz),
            customText: 'Start Quiz',
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCodeCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2120FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF2120FF).withValues(alpha: 0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("QUIZ CODE", style: TextStyle(fontSize: 12, letterSpacing: 1.2, color: Color(0xFF2120FF), fontWeight: FontWeight.bold)),
                Text(quiz.quizCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 4, fontFamily: 'monospace')),
              ],
            ),
          ),
          Obx(() => IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: quiz.quizCode));
              isCopied.value = true;
              Future.delayed(const Duration(seconds: 2), () => isCopied.value = false);
            },
            icon: Icon(isCopied.value ? Icons.check_rounded : Icons.copy_rounded, color: const Color(0xFF2120FF)),
            style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
          )),
        ],
      ),
    );
  }

  Widget _buildParticipantsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Participants List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFF2120FF), borderRadius: BorderRadius.circular(20)),
          child: Text("${quiz.participants.length} Joined", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15)],
    );
  }
}