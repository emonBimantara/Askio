import 'package:askio/Features/Quiz/Model/quiz_result_model.dart';
import 'package:askio/Widgets/history_empty_state.dart';
import 'package:askio/Widgets/history_grouped_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/history_controller.dart';

class HistoryView extends StatelessWidget {
  HistoryView({super.key});

  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Text(
                'Learning Progress',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2120FF)),
                  );
                }

                if (controller.historyList.isEmpty) {
                  return const HistoryEmptyState();
                }

                Map<String, List<QuizResultModel>> groupedHistory = {};
                for (var data in controller.historyList) {
                  final model = QuizResultModel.fromFireStore(data['id'] ?? '', data);
                  groupedHistory.putIfAbsent(model.quizTitle, () => []).add(model);
                }

                final titles = groupedHistory.keys.toList();

                return RefreshIndicator(
                  onRefresh: () async => controller.fetchHistory(),
                  color: const Color(0xFF2120FF),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: titles.length,
                    itemBuilder: (context, index) {
                      final title = titles[index];
                      return HistoryGroupedCard(
                        title: title,
                        attempts: groupedHistory[title]!,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}