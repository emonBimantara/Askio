import 'package:askio/Features/Quiz/Model/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<QuestionModel>> getQuestions(String quizId) async {
    final snapshot = await db
      .collection("quizzes")
      .doc(quizId)
      .collection("questions")
      .get();

    return snapshot.docs.map((doc) {
      return QuestionModel.fromFirestore(
        doc.id, 
        doc.data()
      );
    }).toList();
  }
}