import 'package:askio/Features/Home/Controller/quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddQuizPage extends StatelessWidget {
  AddQuizPage({super.key});

  final AddQuizController controller = Get.put(AddQuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        title: const Text("Buat Kuis Baru"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildQuizInfoCard(),
            const SizedBox(height: 20),
            const Text(
              "Daftar Soal",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildQuestionList(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        );
      }),
    );
  }

  Widget _buildQuizInfoCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail Kuis",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: controller.titleController,
            decoration: const InputDecoration(
              labelText: "Judul Kuis",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: controller.durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Durasi (Menit)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: controller.rulesController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: "Rules (Pisahkan dengan koma)",
              hintText: "Dilarang nyontek, Waktu terbatas",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList() {
    return Obx(
      () => Column(
        children: List.generate(controller.questions.length, (index) {
          final q = controller.questions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Soal ${index + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (controller.questions.length > 1)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removeQuestion(index),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: q['questionText'],
                  decoration: const InputDecoration(
                    labelText: "Pertanyaan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                _buildOptionRows(q),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: q['correctAnswer'],
                  decoration: const InputDecoration(
                    labelText: "Jawaban Benar",
                    border: OutlineInputBorder(),
                  ),
                  items: ['A', 'B', 'C', 'D']
                      .map(
                        (val) => DropdownMenuItem(
                          value: val,
                          child: Text("Opsi $val"),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => q['correctAnswer'] = val!,
                ),
              ],
            ),
          );
        }),
      ),
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
                decoration: const InputDecoration(labelText: "Opsi A"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: q['optionB'],
                decoration: const InputDecoration(labelText: "Opsi B"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: q['optionC'],
                decoration: const InputDecoration(labelText: "Opsi C"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: q['optionD'],
                decoration: const InputDecoration(labelText: "Opsi D"),
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
          icon: const Icon(Icons.add),
          label: const Text("Tambah Soal Lagi"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: controller.saveQuiz,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2120FF),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            "Simpan Kuis & Upload",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
