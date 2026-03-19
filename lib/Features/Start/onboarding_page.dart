// import 'package:askio/Features/Start/onboarding_content.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({super.key});

//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   final PageController controller = PageController();
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: PageView.builder(
//           controller: controller,
//           itemCount: contents.length,
//           onPageChanged: (index) {
//             setState(() {
//               currentIndex = index;
//             });
//           },
//           itemBuilder: (context, index) {
//             return Stack(
//               children: [
//                 Positioned(
//                   top: 40,
//                   left: 0,
//                   right: 0,
//                   child: Image.asset(
//                     contents[index].image,
//                     width: double.infinity,
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),

//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                       vertical: 40,
//                     ),
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(50),
//                         topRight: Radius.circular(50),
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           contents[index].title,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 30,
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         Text(
//                           contents[index].description,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Color(0xFF6C7072),
//                             fontSize: 15,
//                           ),
//                         ),

//                         const SizedBox(height: 80),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),

//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

//         floatingActionButton: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: List.generate(
//                   contents.length,
//                   (index) => Container(
//                     margin: const EdgeInsets.only(right: 6),
//                     width: currentIndex == index ? 20 : 6,
//                     height: 6,
//                     decoration: BoxDecoration(
//                       color: currentIndex == index ? Colors.black : Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(
//                 width: 70,
//                 height: 70,
//                 child: FloatingActionButton(
//                   elevation: 0,
//                   backgroundColor: const Color(0xFF0D0BCC),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   onPressed: () {
//                     if (currentIndex == contents.length - 1) {
//                       Get.offNamed('/login');
//                     } else {
//                       controller.nextPage(
//                         duration: const Duration(milliseconds: 400),
//                         curve: Curves.easeIn,
//                       );
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(23),
//                     child: Image.asset("assets/icons/arrow.png"),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
