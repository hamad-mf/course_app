import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Wait for Firebase user load
    await auth.loadCurrentUser();

    await Future.delayed(Duration(seconds: 1));

    if (!auth.isLoggedIn || auth.currentUserModel == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    print("Logged-in role: ${auth.currentUserModel?.role}");

    if (auth.currentUserModel!.role == "admin") {
      Navigator.pushReplacementNamed(context, '/admin_dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
