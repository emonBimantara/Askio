import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/quiz_model.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<QuizModel>> getQuizzes({String? teacherId}) async {
    try {
      Query query = _db.collection('quizzes');

      if (teacherId != null) {
        query = query.where('teacherId', isEqualTo: teacherId);
      }

      query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        return QuizModel.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      print("Error fetching quizzes: $e");
      return [];
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    await _db.collection('quizzes').doc(quizId).delete();
  }
}

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.exists ? (doc.data()?['role'] ?? 'student') : 'student';
    } catch (e) {
      return 'student';
    }
  }
}
