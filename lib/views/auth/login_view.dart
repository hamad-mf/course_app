import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginView extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: TextStyle(fontSize: 28)),
            SizedBox(height: 20),

            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Email"),
            ),

            SizedBox(height: 10),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),

            SizedBox(height: 20),
            auth.loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      bool success = await auth.login(
                        emailCtrl.text,
                        passwordCtrl.text,
                      );

                      if (success) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: Text("Login"),
                  ),
          ],
        ),
      ),
    );
  }
}
