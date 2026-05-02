import 'package:askio/Features/Home/Controller/add_quiz_controller.dart';
import 'package:askio/Widgets/action_buttons.dart';
import 'package:askio/Widgets/question_list.dart';
import 'package:askio/Widgets/quiz_info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddQuizPage extends StatelessWidget {
  AddQuizPage({super.key});

  final AddQuizController controller = Get.put(AddQuizController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  children: [
                    BackButton(),
                    SizedBox(width: 10),
                    Text(
                      'Create Quiz',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 30,
                      ),
                      children: [
                        QuizInfoCard(controller: controller),

                        const SizedBox(height: 30),
                        const Text(
                          "Question List",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 15),

                        QuestionList(controller: controller), 

                        const SizedBox(height: 30),

                        ActionButtons(controller: controller), 

                        const SizedBox(height: 40),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
