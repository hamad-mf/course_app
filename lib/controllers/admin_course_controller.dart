import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminCourseController extends ChangeNotifier {
  bool loading = false;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// FETCH ALL COURSES
  Stream<QuerySnapshot> fetchCourses() {
    return _db
        .collection("courses")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// DELETE COURSE
  Future<void> deleteCourse(String id) async {
    await _db.collection("courses").doc(id).delete();
  }

  /// UPDATE COURSE
  Future<bool> updateCourse(
    String id,
    String title,
    String description,
    double price,
    String thumbnailUrl,
    List<Map<String, dynamic>> lessons,
  ) async {
    loading = true;
    notifyListeners();

    try {
      await _db.collection("courses").doc(id).update({
        "title": title,
        "description": description,
        "price": price,
        "thumbnailUrl": thumbnailUrl,
        "lessons": lessons,
      });

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      print("Update course error: $e");
      return false;
    }
  }

  /// CREATE COURSE
  Future<bool> createCourse({
    required String title,
    required String description,
    required double price,
    required String thumbnailUrl,
    required List<Map<String, dynamic>> lessons,
  }) async {
    loading = true;
    notifyListeners();

    try {
      await _db.collection("courses").add({
        'title': title,
        'description': description,
        'price': price,
        'thumbnailUrl': thumbnailUrl,
        'lessons': lessons,
        'createdAt': FieldValue.serverTimestamp(),
      });

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      print("Create course error: $e");
      return false;
    }
  }
}
