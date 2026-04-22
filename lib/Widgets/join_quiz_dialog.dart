import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Features/Home/Controller/home_controller.dart';

void showJoinCodeDialog(HomeController controller) {
  Get.dialog(
    Dialog(
      backgroundColor: const Color(0xFFF5EDE2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter Quiz code",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: controller.codeController,
              onChanged: (_) => controller.update(),
              decoration: InputDecoration(
                hintText: "Enter code",
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            GetBuilder<HomeController>(
              builder: (_) {
                final isFilled =
                    controller.codeController.text.trim().isNotEmpty;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isFilled ? controller.joinQuiz : null,
                    icon: const Icon(Icons.search),
                    label: const Text("Search Quiz"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFilled
                          ? const Color(0xFF3D3DFF)
                          : const Color(0xFFBFC2E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}