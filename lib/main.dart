// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: RoleSelectScreen(),
      theme: ThemeData(primarySwatch: Colors.teal),
    ),
  );
}

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
              onPressed: () {
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
              onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('うちマネ（保護者）')),
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

// Child Main Screen
class ChildMainScreen extends StatefulWidget {
  @override
  _ChildMainScreenState createState() => _ChildMainScreenState();
}

class _ChildMainScreenState extends State<ChildMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ChildHomePage(),
    SpendPointPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('うちマネ（こども）')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'つかう',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'れきし'),
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

class ChildHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('子ども用ホーム'));
  }
}

class SpendPointPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ポイントをつかう画面'));
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('履歴画面'));
  }
}
