import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../role_select_screen.dart';

// Parent Main Screen
class ParentMainScreen extends StatefulWidget {
  @override
  _ParentMainScreenState createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ParentHomePage(),
    GivePointPage(),
    SettingPage(),
  ];

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => RoleSelectScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('うちマネ（保護者）'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: '渡す'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
      ),
    );
  }
}

// 各ページ（ダミー）
class ParentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('保護者用ホーム'));
  }
}

class GivePointPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ポイントを渡す画面'));
  }
}

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('設定画面'));
  }
}
