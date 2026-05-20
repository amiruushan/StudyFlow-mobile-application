import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(

        title: const Text(
          "StudyFlow",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.white,

        elevation: 0,

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Welcome Back 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Let's make today productive",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Study Progress Card
            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.blue,

                borderRadius: BorderRadius.circular(24),

              ),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Today's Progress",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "4 / 6 Tasks Completed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ClipRRect(

                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(

                      value: 0.7,

                      minHeight: 10,

                      backgroundColor: Colors.white24,

                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(

              children: [

                Expanded(
                  child: buildActionCard(
                    Icons.book,
                    "Subjects",
                    Colors.orange,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: buildActionCard(
                    Icons.schedule,
                    "Schedule",
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(

              children: [

                Expanded(
                  child: buildActionCard(
                    Icons.task,
                    "Tasks",
                    Colors.purple,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: buildActionCard(
                    Icons.bar_chart,
                    "Progress",
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionCard(
      IconData icon,
      String title,
      Color color,
      ) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

      ),

      child: Column(

        children: [

          CircleAvatar(

            radius: 28,

            backgroundColor: color.withOpacity(0.2),

            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}