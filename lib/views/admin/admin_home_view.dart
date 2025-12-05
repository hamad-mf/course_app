import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class AdminHomeView extends StatelessWidget {
  final FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Welcome Admin, ${auth.currentUserModel?.email ?? ''}'),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Course (stub)'),
              onPressed: () {
                // Example: open AddCourseView or show a dialog
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Create course (example)'),
                    content: Text('This should open add course screen.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('List Users (admin only)'),
              onPressed: () {
                // navigate to admin users list
              },
            )
          ],
        ),
      ),
    );
  }
}
