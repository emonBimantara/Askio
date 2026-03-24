import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddQuizPage extends StatefulWidget {
  const AddQuizPage({super.key});

  @override
  State<AddQuizPage> createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();

  // State untuk nampung daftar soal secara dinamis
  List<Map<String, dynamic>> questions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Kasih 1 soal kosong sebagai awalan
    _addNewQuestionField();
  }

  void _addNewQuestionField() {
    setState(() {
      questions.add({
        'questionText': TextEditingController(),
        'optionA': TextEditingController(),
        'optionB': TextEditingController(),
        'optionC': TextEditingController(),
        'optionD': TextEditingController(),
        'correctAnswer': 'A', // Default dropdown
      });
    });
  }

  void _removeQuestionField(int index) {
    setState(() {
      questions.removeAt(index);
    });
  }

  // LOGIC UTAMA: Nembak ke Firebase pakai Batch Write
  Future<void> _saveQuizToFirebase() async {
    if (titleController.text.isEmpty || durationController.text.isEmpty) {
      Get.snackbar("Error", "Judul dan Durasi wajib diisi!");
      return;
    }

    setState(() => isLoading = true);

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();
      final String teacherId = FirebaseAuth.instance.currentUser!.uid;

      // 1. Bikin doc baru untuk kuis di collection 'quizzes'
      final quizRef = db.collection('quizzes').doc();

      // Aturan (rules) kita pisah pakai koma biar gampang untuk testing
      List<String> rulesList = rulesController.text.isNotEmpty 
          ? rulesController.text.split(',').map((e) => e.trim()).toList()
          : ["Baca doa sebelum mengerjakan"];

      batch.set(quizRef, {
        'title': titleController.text,
        'duration': int.parse(durationController.text),
        'rules': rulesList,
        'teacherId': teacherId, // Stempel Oner (Kepemilikan Guru)
        'totalQuestions': questions.length, // Dinamis ngikutin jumlah soal
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Looping masukin soal ke subcollection 'questions'
      for (var q in questions) {
        final questionRef = quizRef.collection('questions').doc();
        
        // Gabungin opsi jawaban jadi array
        List<String> optionsArray = [
          q['optionA'].text,
          q['optionB'].text,
          q['optionC'].text,
          q['optionD'].text,
        ];

        // Tentukan teks jawaban benar berdasarkan pilihan dropdown (A/B/C/D)
        String correctAnswerText = '';
        if (q['correctAnswer'] == 'A') correctAnswerText = q['optionA'].text;
        if (q['correctAnswer'] == 'B') correctAnswerText = q['optionB'].text;
        if (q['correctAnswer'] == 'C') correctAnswerText = q['optionC'].text;
        if (q['correctAnswer'] == 'D') correctAnswerText = q['optionD'].text;

        batch.set(questionRef, {
          'questionText': q['questionText'].text,
          'options': optionsArray,
          'correctAnswer': correctAnswerText,
        });
      }

      // 3. Eksekusi semua perintah sekaligus!
      await batch.commit();

      Get.back(); // Balik ke halaman sebelumnya
      Get.snackbar("Sukses", "Kuis dan ${questions.length} soal berhasil diupload! 🎉");

    } catch (e) {
      Get.snackbar("Error", "Gagal upload: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        title: const Text("Buat Kuis Baru"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // --- FORM INFO KUIS UTAMA ---
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Detail Kuis", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 15),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Judul Kuis", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Durasi (Menit)", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: rulesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Rules (Pisahkan dengan koma)", 
                        hintText: "Dilarang nyontek, Waktu terbatas",
                        border: OutlineInputBorder()
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              const Text("Daftar Soal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),

              // --- FORM SOAL DINAMIS ---
              ...List.generate(questions.length, (index) {
                final q = questions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Soal ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          if (questions.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeQuestionField(index),
                            )
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: q['questionText'],
                        decoration: const InputDecoration(labelText: "Pertanyaan", border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: TextField(controller: q['optionA'], decoration: const InputDecoration(labelText: "Opsi A", border: OutlineInputBorder()))),
                          const SizedBox(width: 10),
                          Expanded(child: TextField(controller: q['optionB'], decoration: const InputDecoration(labelText: "Opsi B", border: OutlineInputBorder()))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: TextField(controller: q['optionC'], decoration: const InputDecoration(labelText: "Opsi C", border: OutlineInputBorder()))),
                          const SizedBox(width: 10),
                          Expanded(child: TextField(controller: q['optionD'], decoration: const InputDecoration(labelText: "Opsi D", border: OutlineInputBorder()))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: q['correctAnswer'],
                        decoration: const InputDecoration(labelText: "Jawaban Benar", border: OutlineInputBorder()),
                        items: ['A', 'B', 'C', 'D'].map((String val) {
                          return DropdownMenuItem(value: val, child: Text("Opsi $val"));
                        }).toList(),
                        onChanged: (val) {
                          setState(() { q['correctAnswer'] = val!; });
                        },
                      )
                    ],
                  ),
                );
              }),

              // TOMBOL TAMBAH SOAL
              OutlinedButton.icon(
                onPressed: _addNewQuestionField,
                icon: const Icon(Icons.add),
                label: const Text("Tambah Soal Lagi"),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
              
              const SizedBox(height: 30),

              // TOMBOL SIMPAN KUIS
              ElevatedButton(
                onPressed: _saveQuizToFirebase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2120FF),
                  padding: const EdgeInsets.symmetric(vertical: 15)
                ),
                child: const Text("Simpan Kuis & Upload", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 30),
            ],
          ),
    );
  }
}