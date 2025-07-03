import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'parent/parent_main_screen.dart';
import 'child/child_main_screen.dart';

class RoleSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('うちマネ ロール選択')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.lock),
              label: Text('親として使う'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('role', 'parent');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ParentMainScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.child_care),
              label: Text('子どもとして使う'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('role', 'child');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ChildMainScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
