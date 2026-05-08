import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? "";
  final String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<Map<String, String>> getBatchFeedback({
    required List<Map<String, String>> incorrectQuestions,
  }) async {
    if (incorrectQuestions.isEmpty) return {};

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "system",
              "content": """
                You are 'Askio AI', a brilliant and supportive senior student mentor. 
                Your goal is to help students understand their mistakes by providing a 'deep dive' explanation that is easy to digest.

                For each incorrect answer:
                1. Start with a catchy or encouraging opening (e.g., 'Aha! Here is the logic...', 'Don't worry, this one is tricky!').
                2. Explain the core concept behind the correct answer in detail but without using boring jargon.
                3. Explain WHY the student's specific answer might be a common mistake or why it doesn't fit the context.
                4. End with a 'Pro-Tip' or a 'Fun Fact' related to the topic to add extra value.

                IMPORTANT LOGIC RULES:
                1. Trust the 'correctAnswer' provided by the system as the absolute truth.
                2. If the student's answer is mathematically correct but marked 'isCorrect: false', it is likely because there is a MORE COMPREHENSIVE option (e.g., 'Both A and B', 'All of the above'). 
                3. In this case, your job is to explain why the chosen 'correctAnswer' is the most complete and best response, and why the student's answer was only partially correct.

                Rules:
                - Use casual, friendly, and witty English.
                - Length: Aim for a rich paragraph (about 4-6 sentences).
                - IMPORTANT: Output MUST be a FLAT JSON object where each KEY is the 'id' from the input and the VALUE is the explanation string.
                - Use plain text only (no markdown, no bold, no bullet points).
              """,
            },
            {
              "role": "user",
              "content": "Questions data: ${jsonEncode(incorrectQuestions)}",
            },
          ],
          "response_format": {"type": "json_object"},
          "temperature": 0.6,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String content = data['choices'][0]['message']['content'];

        print("AI Response Content: $content");

        Map<String, dynamic> decoded = jsonDecode(content);
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      } else {
        print("Groq Error Status: ${response.statusCode}");
        print("Groq Error Detail: ${response.body}");
      }
    } catch (e) {
      print("Groq Catch Error: $e");
    }
    return {};
  }

  Future<String> getTeacherInsight({
    required Map<String, int> weakPoints,
    required String quizTitle,
  }) async {
    if (weakPoints.isEmpty) {
      return "There is not enough quiz data available for analysis yet.";
    }

    String questionsData = weakPoints.entries
        .map((e) => "- Question: '${e.key}' (Missed by: ${e.value} students)")
        .join("\n");

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "system",
              "content": 
              """
                You are 'Askio AI Specialist', an expert educational consultant. 
                Your task is to analyze quiz results for a teacher and provide actionable teaching insights.
                
                Based on the list of questions that students failed most frequently:
                1. Identify the common conceptual gap (why are they struggling?).
                2. Provide a brief strategy for the teacher to re-teach this topic more effectively.
                3. Keep the tone professional, supportive, and insightful.
                
                Rules:
                - Use concise but impactful language.
                - Format: Use plain text only.
                - Language: English (clear and easy to understand).
              """,
            },
            {
              "role": "user",
              "content":
                  "Quiz Title: $quizTitle\n\nWeak Points Data:\n$questionsData",
            },
          ],
          "temperature": 0.5,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['choices'][0]['message']['content'] ??
            "Failed to generate AI insight.";
      }
    } catch (e) {
      print("Error getting teacher insight: $e");
    }

    return "AI analysis is currently unavailable.";
  }
}
