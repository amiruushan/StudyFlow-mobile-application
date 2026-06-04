import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();

}

class _SubjectScreenState extends State<SubjectScreen> {

  final TextEditingController subjectController = TextEditingController();

  Future<void> addSubject() async {

    if (subjectController.text.trim().isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection("subjects")
        .add({

      "name": subjectController.text.trim(),

      "userId":
      FirebaseAuth.instance.currentUser!.uid,

      "createdAt": Timestamp.now(),

    });

    subjectController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Subjects"),
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("subjects")
            .where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return const Center(
              child: Text(
                "No Subjects Yet",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          final subjects = snapshot.data!.docs;

          return ListView.builder(

            itemCount: subjects.length,

            itemBuilder: (context, index) {

              final subject = subjects[index];

              return Dismissible(

                key: Key(subject.id),

                direction: DismissDirection.endToStart,

                onDismissed: (direction) async {

                  await FirebaseFirestore.instance
                      .collection("subjects")
                      .doc(subject.id)
                      .delete();

                },

                background: Container(

                  color: Colors.red,

                  alignment: Alignment.centerRight,

                  padding: const EdgeInsets.only(right: 20),

                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),

                child: ListTile(

                  leading: const Icon(Icons.book),

                  title: Text(subject['name']),

                  trailing: IconButton(

                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),

                    onPressed: () {

                      final editController =
                      TextEditingController(
                        text: subject['name'],
                      );

                      showDialog(

                        context: context,

                        builder: (context) {

                          return AlertDialog(

                            title: const Text("Edit Subject"),

                            content: TextField(
                              controller: editController,
                            ),

                            actions: [

                              TextButton(

                                onPressed: () {
                                  Navigator.pop(context);
                                },

                                child: const Text("Cancel"),
                              ),

                              ElevatedButton(

                                onPressed: () async {

                                  await FirebaseFirestore.instance
                                      .collection("subjects")
                                      .doc(subject.id)
                                      .update({

                                    "name":
                                    editController.text.trim(),

                                  });

                                  Navigator.pop(context);

                                },

                                child: const Text("Update"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () {

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                title: const Text("Add Subject"),

                content: TextField(

                  controller: subjectController,

                  decoration: const InputDecoration(
                    hintText: "Enter Subject Name",
                  ),
                ),

                actions: [

                  TextButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(

                    onPressed: () async {

                      await addSubject();

                      Navigator.pop(context);

                    },

                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}