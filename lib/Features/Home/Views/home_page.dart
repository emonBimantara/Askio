import 'package:askio/Components/quizzes_card.dart';
import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:askio/Features/Home/Services/quiz_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  final QuizService quizService = QuizService();
  late Future<List<QuizModel>> quizList;

  @override
  void initState() {
    quizList = quizService.getQuizzes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Evening, ${user?.displayName ?? "User"}"),
                    SizedBox(height: 5),
                    Text(
                      "Let's test your knowledge",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(radius: 22, child: Icon(Icons.person)),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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

                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF2120FF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.qr_code, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text("Code", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: FutureBuilder<List<QuizModel>>(
                      future: quizList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Error"));
                        }

                        final quizzes = snapshot.data ?? [];

                        if (quizzes.isEmpty) {
                          return Center(child: Text("No Quizzes Available"));
                        }

                        return ListView.builder(
                          itemCount: quizzes.length,
                          itemBuilder: (context, index) {
                            final quiz = quizzes[index];
                            return QuizzesCard(quiz: quiz, onTap: () {});
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
