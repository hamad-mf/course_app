import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_course_controller.dart';

class EditCourseView extends StatefulWidget {
  final String courseId;
  final Map<String, dynamic> courseData;

  const EditCourseView({
    super.key,
    required this.courseId,
    required this.courseData,
  });

  @override
  State<EditCourseView> createState() => _EditCourseViewState();
}

class _EditCourseViewState extends State<EditCourseView> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final thumbCtrl = TextEditingController();

  List<Map<String, dynamic>> lessons = [];

  @override
  void initState() {
    super.initState();
    titleCtrl.text = widget.courseData["title"];
    descCtrl.text = widget.courseData["description"];
    priceCtrl.text = widget.courseData["price"].toString();
    thumbCtrl.text = widget.courseData["thumbnailUrl"];
    lessons = List<Map<String, dynamic>>.from(widget.courseData["lessons"]);
  }

  @override
  Widget build(BuildContext context) {
    final adminCtrl = Provider.of<AdminCourseController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Course")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              controller: thumbCtrl,
              decoration:
                  const InputDecoration(labelText: "Thumbnail Image URL"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Lessons",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            ...lessons.map((e) => ListTile(
                  title: Text(e["title"]),
                  subtitle: Text("Image URL: ${e["imageUrl"]}"),
                )),

            const SizedBox(height: 20),

            adminCtrl.loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      double? price = double.tryParse(priceCtrl.text);

                      if (price == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Enter valid numeric price")),
                        );
                        return;
                      }

                      bool success = await adminCtrl.updateCourse(
                        widget.courseId,
                        titleCtrl.text,
                        descCtrl.text,
                        price,
                        thumbCtrl.text,
                        lessons,
                      );

                      if (success) Navigator.pop(context);
                    },
                    child: const Text("Save Changes"),
                  ),
          ],
        ),
      ),
    );
  }
}
