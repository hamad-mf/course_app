import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _fs = FirestoreService();

  bool loading = false;
  UserModel? currentUserModel;

  // convenience
  bool get isLoggedIn => _authService.currentUser != null;
  bool get isAdmin => currentUserModel?.role == 'admin';

  // Registration with role (default 'user')
  Future<bool> register({
    required String email,
    required String password,
    String name = '',
    String role = 'user',
  }) async {
    loading = true;
    notifyListeners();

    try {
      final user = await _authService.registerWithRole(
        email: email,
        password: password,
        name: name,
        role: role,
      );

      if (user != null) {
        currentUserModel = await _fs.fetchUserModel(user.uid);
        loading = false;
        notifyListeners();
        return true;
      } else {
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      print('Register error: $e');
      return false;
    }
  }

  // Login and load user model
  Future<bool> login(String email, String password) async {
    loading = true;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        currentUserModel = await _fs.fetchUserModel(user.uid);
        loading = false;
        notifyListeners();
        return true;
      } else {
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUserModel = null;
    notifyListeners();
  }

  // Load current user model (useful on app startup)
  Future<void> loadCurrentUser() async {
    final user = _authService.currentUser;
    if (user != null) {
      currentUserModel = await _fs.fetchUserModel(user.uid);
    } else {
      currentUserModel = null;
    }
    notifyListeners();
  }
}
