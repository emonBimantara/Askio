import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/quiz_result_model.dart';

class QuizResultService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> saveQuiz(QuizResultModel result) async {
    try {
      String uniqueDocId = "${result.userId}_${result.quizId}";

      await db.collection('user_results').add(result.toMap());
    } catch (e) {
      print("ERROR saveQuiz: $e");
    }
  }

  Future<List<QuizResultModel>> getQuizResult(String userId) async {
    try {
      final snapshot = await db
          .collection('user_results')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return QuizResultModel.fromFireStore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print("ERROR getQuizResult: $e");
      return [];
    }
  }
}
