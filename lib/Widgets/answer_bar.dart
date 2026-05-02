import 'package:flutter/material.dart';

class AnswerBar extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerBar({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey,
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 10 : 0,
                  height: isSelected ? 10 : 0,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
