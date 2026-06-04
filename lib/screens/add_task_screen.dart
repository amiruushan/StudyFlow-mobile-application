import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final TextEditingController taskController =
  TextEditingController();

  DateTime? selectedDate;
  String? selectedSubject;

  Future<void> pickDate() async {

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> saveTask() async {

    if (taskController.text.isEmpty) {
      _showErrorSnackBar("please enter a task");
      return;
    }

    if(selectedDate == null){
      _showErrorSnackBar("please select a due date");
    }

    await FirebaseFirestore.instance.collection("tasks").add({

      "title": taskController.text.trim(),
      "isDone": false,
      "userId":
      FirebaseAuth.instance.currentUser!.uid,
      "createdAt": Timestamp.now(),
      "dueDate": Timestamp.fromDate(selectedDate!)

    });

    Navigator.pop(context);

  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Task"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller: taskController,

              decoration: InputDecoration(

                hintText: "Enter task",

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection("subjects")
                  .where(
                "userId",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final subjects = snapshot.data!.docs;

                return DropdownButtonFormField<String>(

                  value: selectedSubject,

                  decoration: const InputDecoration(
                    labelText: "Select Subject",
                    border: OutlineInputBorder(),
                  ),

                  items: subjects.map((subject) {

                    return DropdownMenuItem<String>(

                      value: subject['name'],

                      child: Text(subject['name']),
                    );

                  }).toList(),

                  onChanged: (value) {

                    setState(() {
                      selectedSubject = value;
                    });

                  },
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: pickDate,

              child: Text(

                selectedDate == null
                    ? "Select Due Date"
                    : "Due: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",

              ),
            ),

            const SizedBox(height: 20),

            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                onPressed: saveTask,

                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.blue,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: const Text(
                  "Save Task",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}