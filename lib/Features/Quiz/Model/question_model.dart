class QuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final String correctAnswerIndex;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex
  });

  factory QuestionModel.fromFirestore(String id, Map<String, dynamic> data){
    return QuestionModel(
      id: id, 
      questionText: data["questionText"] ?? "No Question", 
      options: List<String>.from(data["options"] ?? []), 
      correctAnswerIndex: data["correctAnswerIndex"] ?? 0
    );
  }
}