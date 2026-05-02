import 'package:flutter/material.dart';

class OptionRows extends StatelessWidget {
  final Map<String, dynamic> q;

  const OptionRows({super.key, required this.q});

  InputDecoration _customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: q['optionA'],
                decoration: _customInputDecoration("Option A"),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: q['optionB'],
                decoration: _customInputDecoration("Option B"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: q['optionC'],
                decoration: _customInputDecoration("Option C"),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: q['optionD'],
                decoration: _customInputDecoration("Option D"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}