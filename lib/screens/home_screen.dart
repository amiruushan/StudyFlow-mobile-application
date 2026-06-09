import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_task_screen.dart';
import 'login_screen.dart';
import 'edit_task_screen.dart';
import 'subject_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? selectedFilterSubject;

  @override
  Widget build(BuildContext context) {

    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(

        title: const Text(
          "StudyFlow",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(

            onPressed: () async {

              await FirebaseAuth.instance.signOut();

              // Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },

            icon: const Icon(Icons.logout),
          ),
        ],

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

            StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection("subjects")
                  .where(
                "userId",
                isEqualTo: currentUser!.uid,
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final subjects = snapshot.data!.docs;

                return DropdownButtonFormField<String>(

                  value: selectedFilterSubject,

                  decoration: const InputDecoration(
                    labelText: "Filter by Subject",
                    border: OutlineInputBorder(),
                  ),

                  items: [

                    const DropdownMenuItem(
                      value: null,
                      child: Text("All Subjects"),
                    ),

                    ...subjects.map((subject) {

                      return DropdownMenuItem<String>(
                        value: subject['name'],
                        child: Text(subject['name']),
                      );

                    }),

                  ],

                  onChanged: (value) {

                    setState(() {

                      selectedFilterSubject = value;

                    });

                  },
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Your Tasks",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(

              child: StreamBuilder(

                stream: FirebaseFirestore.instance
                    .collection("tasks")
                    .where("userId", isEqualTo: currentUser!.uid,)
                    // .orderBy("createdAt", descending: true,)
                    .snapshots(),

                builder: (context, snapshot) {

                  // Loading
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // No Data
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {

                    return const Center(
                      child: Text(
                        "No Tasks Yet",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  final allTasks = snapshot.data!.docs;

                  final tasks = selectedFilterSubject == null

                      ? allTasks

                      : allTasks.where((task) {

                    return task['subject'] ==
                        selectedFilterSubject;

                  }).toList();

                  final totalTasks = tasks.length;
                  final completedTasks  = tasks.where((task) => task['isDone'] == true).length;
                  final pendingTasks = tasks.where((task) => task['isDone']==false).length;

                  final progress = totalTasks == 0
                      ? 0.0
                      : completedTasks / totalTasks;

                  return ListView.builder(

                    itemCount: totalTasks,

                    itemBuilder: (context, index) {

                      final task = tasks[index];

                      final isDone = task['isDone'];

                      // Get due date safely
                      final dueDateTimestamp = task['dueDate'];
                      String dueDateText = "No due date";

                      final subject = task['subject'];

                      if (dueDateTimestamp != null) {
                        final dueDate = dueDateTimestamp.toDate();
                        dueDateText = "${dueDate.day}/${dueDate.month}/${dueDate.year}";
                      }

                      return Dismissible(

                          key: Key(task.id),

                          direction: DismissDirection.endToStart,

                          onDismissed: (direction) async {

                            await FirebaseFirestore.instance
                                .collection("tasks")
                                .doc(task.id)
                                .delete();

                          },

                          background: Container(

                            alignment: Alignment.centerRight,

                            padding: const EdgeInsets.only(right: 20),

                            decoration: BoxDecoration(

                              color: Colors.red,

                              borderRadius: BorderRadius.circular(20),

                            ),

                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () async {

                              await FirebaseFirestore.instance
                                  .collection("tasks")
                                  .doc(task.id)
                                  .update({

                                "isDone": !isDone,

                              });

                            },

                            child: Container(

                              margin: const EdgeInsets.only(bottom: 15),

                              padding: const EdgeInsets.all(20),

                              decoration: BoxDecoration(

                                color: Colors.white,

                                borderRadius: BorderRadius.circular(20),

                              ),

                              child: Row(

                                children: [

                                  CircleAvatar(
                                    backgroundColor:
                                    Colors.blue.withOpacity(0.2),

                                    child: Icon(

                                      isDone
                                          ? Icons.check_circle
                                          : Icons.task_alt,

                                      color:
                                      isDone
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(

                                    child: Column(

                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [

                                        Text(

                                          task['title'],

                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,

                                            decoration:
                                            isDone
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,

                                            color:
                                            isDone
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(

                                          "Due: $dueDateText",

                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          "Subject: $subject",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  IconButton(onPressed: (){

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditTaskScreen(
                                              taskId: task.id,
                                              oldTitle: task['title'],
                                            oldDueDate: task['dueDate'],
                                          )
                                      )
                                    );

                                  },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      );
                    },
                  );
                },
              ),
            ),

            Row(

              children: [

                Expanded(
                  child: GestureDetector(

                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubjectScreen(),
                        ),
                      );

                    },

                    child: buildActionCard(
                      Icons.book,
                      "Subjects",
                      Colors.orange,
                    ),
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
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          print('add btn');
          Navigator.push(

            context,

            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );

        },

        backgroundColor: Colors.blue,

        child: const Icon(Icons.add),

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