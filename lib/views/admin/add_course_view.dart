import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_course_controller.dart';

class AddCourseView extends StatefulWidget {
  const AddCourseView({Key? key}) : super(key: key);

  @override
  State<AddCourseView> createState() => _AddCourseViewState();
}

class _AddCourseViewState extends State<AddCourseView> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final thumbnailUrlCtrl = TextEditingController();

  List<Map<String, dynamic>> lessons = [];

  void addLessonDialog() {
    final lessonTitleCtrl = TextEditingController();
    final lessonImageCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: const Text("Add Lesson"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lessonTitleCtrl,
                decoration: const InputDecoration(labelText: "Lesson Title"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lessonImageCtrl,
                decoration: const InputDecoration(labelText: "Lesson Image URL"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (lessonTitleCtrl.text.isEmpty ||
                    lessonImageCtrl.text.isEmpty) return;

                lessons.add({
                  "title": lessonTitleCtrl.text,
                  "imageUrl": lessonImageCtrl.text,
                });

                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminCtrl = Provider.of<AdminCourseController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Course")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Course Title"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: thumbnailUrlCtrl,
                decoration:
                    const InputDecoration(labelText: "Thumbnail Image URL"),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Lessons",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: addLessonDialog,
                    child: const Text("+ Add Lesson"),
                  ),
                ],
              ),

              ...lessons.map(
                (e) => ListTile(
                  title: Text(e["title"]),
                  subtitle: Text("Image URL: ${e["imageUrl"]}"),
                ),
              ),

              const SizedBox(height: 20),

              adminCtrl.loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (titleCtrl.text.isEmpty ||
                            descCtrl.text.isEmpty ||
                            priceCtrl.text.isEmpty ||
                            thumbnailUrlCtrl.text.isEmpty ||
                            lessons.isEmpty) {
                          return;
                        }

                        bool success = await adminCtrl.createCourse(
                          title: titleCtrl.text,
                          description: descCtrl.text,
                          price: double.parse(priceCtrl.text),
                          thumbnailUrl: thumbnailUrlCtrl.text,
                          lessons: lessons,
                        );

                        if (success) Navigator.pop(context);
                      },
                      child: const Text("Publish Course"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
