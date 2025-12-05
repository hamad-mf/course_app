// lib/models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String courseId;
  final double amount;
  final String status;
  final DateTime? createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.amount,
    required this.status,
    this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    Timestamp? ts;
    if (map['createdAt'] is Timestamp) {
      ts = map['createdAt'] as Timestamp;
    }
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      courseId: map['courseId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      status: map['status'] ?? '',
      createdAt: ts != null ? ts.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
