// main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/role_select_screen.dart';
import 'screens/parent/parent_main_screen.dart';
import 'screens/child/child_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final role = prefs.getString('role');

  runApp(
    MaterialApp(
      home: role == 'parent'
          ? ParentMainScreen()
          : role == 'child'
          ? ChildMainScreen()
          : RoleSelectScreen(),
      theme: ThemeData(primarySwatch: Colors.teal),
    ),
  );
}
