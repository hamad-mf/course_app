import 'package:course_app/views/admin/add_course_view.dart';
import 'package:course_app/views/admin/admin_dashboard_view.dart';
import 'package:course_app/views/admin/admin_home_view.dart';
import 'package:course_app/views/admin/courses_list_view.dart';
import 'package:course_app/views/auth/login_view.dart';
import 'package:course_app/views/home/home_view.dart';
import 'package:course_app/views/splash/splash_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashView());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeView());
      case '/admin_home':
        return MaterialPageRoute(builder: (_) => AdminHomeView());
      case '/admin_dashboard':
        return MaterialPageRoute(builder: (_) => AdminDashboardView());
      case '/add_course':
        return MaterialPageRoute(builder: (_) => AddCourseView());

      /// ------------------- FIX ADDED HERE -------------------
      case '/admin_courses':
        return MaterialPageRoute(builder: (_) => CoursesListView());

      /// -------------------------------------------------------

      default:
        return MaterialPageRoute(builder: (_) => SplashView());
    }
  }
}
