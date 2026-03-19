class QuizModel {
  final String id;
  final int duration;
  final String title;
  final int totalQuestions;
  final List<String> rules;

  QuizModel({
    required this.id,
    required this.duration,
    required this.title,
    required this.totalQuestions,
    required this.rules,
  });

  factory QuizModel.fromFirestore(String id, Map<String, dynamic> data) {
    return QuizModel(
      id: id,
      duration: data['duration'] ?? 0,
      title: data['title'] ?? 'No Title',
      totalQuestions: data['totalQuestions'] ?? 0,
      rules: (data['rules'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
