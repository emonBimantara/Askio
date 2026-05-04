import 'package:flutter/material.dart';

class QuizPreviewParticipantsList extends StatelessWidget {
  final List<dynamic> participants;

  const QuizPreviewParticipantsList({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: participants.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final participant = participants[index];
        String name = (participant is Map) 
            ? (participant['name'] ?? "Unknown") 
            : participant.toString();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF2120FF),
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 15),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}