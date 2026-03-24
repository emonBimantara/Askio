import 'package:askio/Components/quizzes_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

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
                      Text("Good Evening, ${user?.displayName ?? "User"}"),
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
                    onTap: controller.authController.logout,
                    child: const CircleAvatar(
                      radius: 22,
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
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
                              print("Buka input kode");
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
                                      : "Code",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.refreshQuizzes(),
                        child: controller.quizzes.isEmpty
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
                                        _showDeleteDialog(quiz.id, controller);
                                      }
                                    },
                                    child: QuizzesCard(
                                      quiz: quiz,
                                      onTap: () {},
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
      }),
    );
  }

  void _showDeleteDialog(String quizId, HomeController controller) {
    Get.defaultDialog(
      title: "Hapus Kuis",
      middleText: "Yakin mau menghapus kuis ini?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black,
      onConfirm: () {
        Get.back();
        controller.deleteQuiz(quizId);
      },
    );
  }
}
