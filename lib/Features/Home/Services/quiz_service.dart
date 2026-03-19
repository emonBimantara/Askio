import 'package:askio/Features/Home/Model/quiz_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<QuizModel>> getQuizzes() async {
    try {
      final snapshot = await db.collection('quizzes').get();

      return snapshot.docs.map((doc) {
        return QuizModel.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
