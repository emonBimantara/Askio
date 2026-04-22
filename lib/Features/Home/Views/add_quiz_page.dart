import 'package:askio/Features/Home/Controller/quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddQuizPage extends StatelessWidget {
  AddQuizPage({super.key});

  final AddQuizController controller = Get.put(AddQuizController());

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  children: [
                    BackButton(),
                    SizedBox(width: 10),
                    Text(
                      'Create Quiz',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                      children: [
                        _buildQuizInfoCard(),
                        const SizedBox(height: 30),
                        const Text(
                          "Question List",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 15),
                        _buildQuestionList(),
                        const SizedBox(height: 30),
                        _buildActionButtons(),
                        const SizedBox(height: 40), 
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quiz Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.titleController,
          decoration: _customInputDecoration("e.g., Saturday Night Quiz"),
        ),
        
        const SizedBox(height: 20),
        
        const Text("Duration (Minutes)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.durationController,
          keyboardType: TextInputType.number,
          decoration: _customInputDecoration("e.g., 15"),
        ),
        
        const SizedBox(height: 20),
        
        const Text("Quiz Rules", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.rulesController,
          maxLines: 3,
          decoration: _customInputDecoration("(Type with comma)"),
        ),
      ],
    );
  }

  Widget _buildQuestionList() {
    return Column(
      children: List.generate(controller.questions.length, (index) {
        final q = controller.questions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 25),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Question ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF2120FF)),
                  ),
                  if (controller.questions.length > 1)
                    InkWell(
                      onTap: () => controller.removeQuestion(index),
                      child: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                ],
              ),
              const Divider(height: 30),
              
              const Text("Quiz Question", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: q['questionText'],
                decoration: _customInputDecoration("Enter your question here..."),
              ),
              
              const SizedBox(height: 20),
              _buildOptionRows(q),
              
              const SizedBox(height: 20),
              const Text("Correct Answer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: q['correctAnswer'],
                decoration: _customInputDecoration(""), 
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ['A', 'B', 'C', 'D'].map((val) => DropdownMenuItem(
                  value: val,
                  child: Text("Option $val", style: const TextStyle(fontWeight: FontWeight.w500)),
                )).toList(),
                onChanged: (val) => q['correctAnswer'] = val!,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOptionRows(Map<String, dynamic> q) {
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

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: controller.addNewQuestion,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text("Add Another Question", style: TextStyle(fontSize: 16)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2120FF),
            side: const BorderSide(color: Color(0xFF2120FF)),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: controller.saveQuiz,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2120FF),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "Save & Upload Quiz",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}