import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _fs = FirestoreService();

  Future<User?> login(String email, String password) async {
    final UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  /// Register and create a user document with role (default "user")
  Future<User?> registerWithRole({
    required String email,
    required String password,
    String name = '',
    String role = 'user',
  }) async {
    final UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      await _fs.createUserDoc(
        uid: user.uid,
        email: email,
        name: name,
        role: role,
      );
    }
    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
