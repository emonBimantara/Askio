import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2120FF), width: 1.5),
        ),
      ),

      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),

      items: const [
        DropdownMenuItem(
          value: 'student',
          child: Row(
            children: [
              Icon(Icons.school, size: 18),
              SizedBox(width: 10),
              Text("Student"),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'teacher',
          child: Row(
            children: [
              Icon(Icons.person, size: 18),
              SizedBox(width: 10),
              Text("Teacher"),
            ],
          ),
        ),
      ],

      onChanged: onChanged,
    );
  }
}
