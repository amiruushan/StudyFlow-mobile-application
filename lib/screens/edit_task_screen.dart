import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskScreen extends StatefulWidget {

  final String taskId;
  final String oldTitle;

  const EditTaskScreen({
    super.key,
    required this.taskId,
    required this.oldTitle,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {

  late TextEditingController taskController;

  @override
  void initState() {

    super.initState();

    taskController =
        TextEditingController(text: widget.oldTitle);

  }

  Future<void> updateTask() async {

    if (taskController.text.trim().isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(widget.taskId)
        .update({

      "title": taskController.text.trim(),

    });

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Task"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller: taskController,

              decoration: const InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: updateTask,

                child: const Text("Update Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}