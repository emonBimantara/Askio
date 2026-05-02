class QuizModel {
  final String id;
  final int duration;
  final String title;
  final int totalQuestions;
  final String quizCode;
  final List<String> rules;
  final String teacherId;
  final List<dynamic> participants;

  QuizModel({
    required this.id,
    required this.duration,
    required this.title,
    required this.totalQuestions,
    required this.quizCode,
    required this.rules,
    required this.teacherId,
    required this.participants
  });

  factory QuizModel.fromFirestore(String id, Map<String, dynamic> data) {
    return QuizModel(
      id: id,
      duration: data['duration'] ?? 0,
      title: data['title'] ?? 'No Title',
      totalQuestions: data['totalQuestions'] ?? 0,
      quizCode: data["quizCode"] ?? "",
      rules: (data['rules'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      teacherId: data['teacherId'] ?? '',
      participants: data['participants'] ?? [],
    );
  }
}
