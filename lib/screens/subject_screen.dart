import 'package:flutter/material.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subjects"),
      ),
      body: const Center(
        child: Text(
          "No Subjects Yet",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}