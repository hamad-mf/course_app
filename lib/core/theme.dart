import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF7B61A1),
    scaffoldBackgroundColor: Color(0xFF0D0D0D),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0D0D0D),
      elevation: 0,
    ),
    cardColor: Color(0xFF1A1A1A),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.grey),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1A1A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
