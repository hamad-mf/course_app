import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/admin_course_controller.dart';
import 'edit_course_view.dart';

class CoursesListView extends StatelessWidget {
  const CoursesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCtrl = Provider.of<AdminCourseController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Courses")),
      body: StreamBuilder<QuerySnapshot>(
        stream: adminCtrl.fetchCourses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("No courses added yet."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final id = docs[i].id;

              return Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: Image.network(
                    data["thumbnailUrl"],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(data["title"]),
                  subtitle: Text("₹${data["price"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EDIT
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditCourseView(courseId: id, courseData: data),
                            ),
                          );
                        },
                      ),

                      // DELETE
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("Delete Course?"),
                                content: const Text(
                                    "This action cannot be undone."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await adminCtrl.deleteCourse(id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
