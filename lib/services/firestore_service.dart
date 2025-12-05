import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserDoc({
    required String uid,
    required String email,
    String name = '',
    String role = 'user',
  }) async {
    final user = UserModel(uid: uid, email: email, name: name, role: role);
    await _db.collection('users').doc(uid).set(user.toMap());
  }

  Future<UserModel?> fetchUserModel(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    return UserModel.fromMap(snap.data()!);
  }

  // Example admin-only action: create course (admin must call this)
  Future<void> createCourse(Map<String, dynamic> courseData) async {
    await _db.collection('courses').add({
      ...courseData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // update user role (admin)
  Future<void> updateUserRole(String uid, String role) async {
    await _db.collection('users').doc(uid).update({'role': role});
  }
}
