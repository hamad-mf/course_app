import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final double price;
  final List<Map<String, dynamic>> lessons;
  final Timestamp createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.price,
    required this.lessons,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'price': price,
      'lessons': lessons,
      'createdAt': createdAt,
    };
  }

  factory CourseModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      thumbnailUrl: data['thumbnailUrl'],
      price: (data['price'] ?? 0).toDouble(),
      lessons: List<Map<String, dynamic>>.from(data['lessons'] ?? []),
      createdAt: data['createdAt'],
    );
  }
}
