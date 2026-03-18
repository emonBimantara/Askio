import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF3D3D3D),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'General Knowledge',
                    style: TextStyle(
                      color: Color(0xFFC9353F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '2 Min',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Saturday night Quiz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text('13 Quizzes', style: TextStyle(color: Colors.white)),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 18, child: Icon(Icons.person)),
                    SizedBox(width: 7),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shared By',
                          style: TextStyle(color: Color(0xFFE7E7E7)),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Brandon Matrovs",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2120FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Start Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
