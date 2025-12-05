// lib/controllers/admin_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class AdminController with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;

  int totalUsers = 0;
  int totalCourses = 0;
  double totalSales = 0.0;
  List<OrderModel> recentOrders = [];

  // load all stats
  Future<void> loadDashboardStats() async {
    loading = true;
    notifyListeners();

    try {
      final usersSnap = await _db.collection('users').get();
      totalUsers = usersSnap.docs.length;

      final coursesSnap = await _db.collection('courses').get();
      totalCourses = coursesSnap.docs.length;

      // fetch latest 200 orders (adjust as needed). We sum amounts client-side.
      final ordersSnap = await _db
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .limit(200)
          .get();

      double sales = 0.0;
      recentOrders = ordersSnap.docs.map((d) {
        final map = d.data();
        final amount = (map['amount'] ?? 0).toDouble();
        sales += amount;
        return OrderModel.fromMap({
          'id': d.id,
          ...map,
        });
      }).toList();

      totalSales = sales;

    } catch (e) {
      // handle / log error as you prefer
      print('AdminController.loadDashboardStats error: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // refresh single pieces if needed
  Future<void> refreshOrders() async {
    await loadDashboardStats();
  }
}
