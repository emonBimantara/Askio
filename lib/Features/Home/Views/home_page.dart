import 'package:askio/Features/Home/Views/home_view.dart'; 
import 'package:askio/Features/Home/Views/history_view.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());
  final RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    HomeView(),
    HistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[currentIndex.value]),

      bottomNavigationBar: Obx(() {
        if (controller.userRole.value == 'student') {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex.value,
              onTap: (index) => currentIndex.value = index,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF2120FF),
              unselectedItemColor: Colors.grey.shade400,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  activeIcon: Icon(Icons.history),
                  label: 'History',
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }
}