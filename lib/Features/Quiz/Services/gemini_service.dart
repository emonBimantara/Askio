import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-3.1-flash-lite',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
  }

  Future<Map<String, String>> getBatchFeedback({
    required List<Map<String, String>> incorrectQuestions,
  }) async {
    if (_apiKey.isEmpty) return {};
    if (incorrectQuestions.isEmpty) return {};

    String prompt =
        """
          You are an encouraging, witty, and tech-savvy AI mentor for an app called Askio. 
          A student just missed some questions, and your job is to help them have a 'lightbulb moment' without being boring.

          Questions List:
          ${jsonEncode(incorrectQuestions)}

          Task:
          - For each question, explain the logic behind the correct answer in a way that's easy to visualize.
          - Tone: Witty, casual (like a senior student helping a friend), and very supportive.
          - Structure: Start with a cool opening (e.g., "Think of it this way..." or "Here's the trick..."), explain the 'why', and finish with a quick tip or 'fun fact' related to the topic.
          - Length: Max 3-4 concise but insightful sentences.
          
          Constraints:
          - Return strictly in JSON format.
          - Key: "id" (from the list).
          - Value: "explanation".
          - Use plain text only, no markdown symbols.
        """;

    for (int i = 0; i < 3; i++) {
      try {
        final response = await _model.generateContent([Content.text(prompt)]);
        final String? text = response.text;

        if (text != null) {
          Map<String, dynamic> decoded = jsonDecode(text);
          return decoded.map((key, value) => MapEntry(key, value.toString()));
        }
      } catch (e) {
        debugPrint("Detail Error Gemini: $e");
        await Future.delayed(Duration(seconds: 2 * (i + 1)));
      }
    }
    return {};
  }
}
