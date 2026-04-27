import 'package:askio/Components/quizzes_card.dart';
import 'package:askio/Features/Home/Controller/home_controller.dart';
import 'package:askio/Widgets/delete_quiz_dialog.dart';
import 'package:askio/Widgets/home_skeleton.dart';
import 'package:askio/Widgets/join_quiz_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.authController.user;

      return Column(
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome, ${controller.userName.value}"),
                    const SizedBox(height: 5),
                    const Text(
                      "Let's test your knowledge",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                      title: "Logout",
                      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      middleText: "Are you sure you want to log out?",
                      textConfirm: "Yes, Logout",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.redAccent,
                      cancelTextColor: const Color(0xFF2120FF),
                      radius: 15,
                      onConfirm: () {
                        Get.back();
                        controller.authController.logout(); 
                      },
                    );
                  },
                  child: const CircleAvatar(
                    radius: 22,
                    child: Icon(Icons.logout, size: 20),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
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
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quizzes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Choose a quiz to start",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          if (controller.userRole.value == 'teacher') {
                            Get.toNamed('/addQuiz');
                          } else {
                            showJoinCodeDialog(controller);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2120FF),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                controller.userRole.value == 'teacher'
                                    ? Icons.add
                                    : Icons.qr_code,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                controller.userRole.value == 'teacher'
                                    ? "Add Quiz"
                                    : "Join Quiz",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => controller.refreshQuizzes(),

                      child: controller.isLoading.value
                          ? const HomeSkeleton()
                          : controller.quizzes.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 200),
                                Center(child: Text("No Quizzes Available")),
                              ],
                            )
                          : ListView.builder(
                              itemCount: controller.quizzes.length,
                              itemBuilder: (context, index) {
                                final quiz = controller.quizzes[index];

                                return GestureDetector(
                                  onLongPress: () {
                                    if (controller.userRole.value ==
                                        'teacher') {
                                      showDeleteQuizDialog(quiz.id, controller);
                                    }
                                  },
                                  child: QuizzesCard(
                                    quiz: quiz,
                                    onTap: () {
                                      Get.toNamed(
                                        '/quizPreview',
                                        arguments: quiz,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
