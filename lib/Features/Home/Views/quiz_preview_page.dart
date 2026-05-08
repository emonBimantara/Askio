import 'package:askio/Components/custom_button.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Home/Controller/home_controller.dart';
import 'package:askio/Features/Quiz/Services/groq_service.dart';
import 'package:askio/Features/Quiz/Services/quiz_result_service.dart';
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
  final QuizResultService _resultService = QuizResultService();

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
                  if (isTeacher)
                    _buildTeacherContent()
                  else
                    _buildStudentContent(),
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
          const Text(
            'Quiz Detail',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
              Text(
                quiz.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "${quiz.totalQuestions} Questions",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
          Text(
            "${quiz.duration} Min",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share this code with your students:',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          _buildQuizCodeCard(),
          const SizedBox(height: 25),
          const Divider(thickness: 1, color: Color(0xFFE8ECF4)),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleShowInsights(),
              icon: const Icon(Icons.analytics_outlined),
              label: const Text("View Class Weak Points"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2120FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildParticipantsHeader(),
          const SizedBox(height: 15),
          Expanded(
            child: quiz.participants.isEmpty
                ? const QuizPreviewEmptyParticipants()
                : QuizPreviewParticipantsList(
                    participants: quiz.participants,
                    quizId: quiz.id,
                  ),
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

  void _handleShowInsights() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFF2120FF))),
      barrierDismissible: false,
    );

    try {
      final allResults = await _resultService.getAllParticipantResults(quiz.id);
      final analysis = _resultService.analyzeWeakPoints(allResults);

      if (analysis.isEmpty) {
        Get.back();
        Get.snackbar(
          "Info",
          "There is not enough quiz data available for analysis.",
        );
        return;
      }

      final GroqService groq = GroqService();

      final aiInsight = await groq.getTeacherInsight(
        weakPoints: Map.fromEntries(analysis.entries.take(3)),
        quizTitle: quiz.title,
      );

      Get.back();

      _showInsightBottomSheet(analysis, aiInsight);
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to process data: $e");
    }
  }

  void _showInsightBottomSheet(Map<String, int> analysis, String aiInsight) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Class Insights",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Focus on these areas to help your students",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 25),
              ...analysis.entries.take(3).map((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "${e.value} Failed",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2120FF), Color(0xFF5352FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2120FF).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                        SizedBox(width: 10),
                        Text(
                          "Askio AI Mentor",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      aiInsight,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildStudentContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please read the rules carefully:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: quiz.rules
                  .map((rule) => QuizRuleItem(rule: rule))
                  .toList(),
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
        border: Border.all(
          color: const Color(0xFF2120FF).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "QUIZ CODE",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.2,
                    color: Color(0xFF2120FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  quiz.quizCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 4,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: quiz.quizCode));
                isCopied.value = true;
                Future.delayed(
                  const Duration(seconds: 2),
                  () => isCopied.value = false,
                );
              },
              icon: Icon(
                isCopied.value ? Icons.check_rounded : Icons.copy_rounded,
                color: const Color(0xFF2120FF),
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Participants List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2120FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "${quiz.participants.length} Joined",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15),
      ],
    );
  }
}
