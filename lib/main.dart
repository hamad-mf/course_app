import 'package:course_app/controllers/admin_course_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'controllers/admin_controller.dart';
import 'firebase_options.dart'; // IMPORTANT (auto-generated)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // REQUIRED for Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminController()),
        ChangeNotifierProvider(create: (_) => AdminCourseController()),
      ],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
