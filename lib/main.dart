// main.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('uchimane.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE points (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT,
        amount INTEGER,
        type TEXT,
        date TEXT
      )
    ''');
  }
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

// Child Main Screen
class ChildMainScreen extends StatefulWidget {
  @override
  _ChildMainScreenState createState() => _ChildMainScreenState();
}

class _ChildMainScreenState extends State<ChildMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ChildHomePage(),
    EarnPointPage(),
    SpendPointPage(),
    HistoryPage(),
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
        title: Text('うちマネ（こども）'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //4タブ化の際に追加
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'ためる'), // 追加
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

class ChildHomePage extends StatefulWidget {
  @override
  _ChildHomePageState createState() => _ChildHomePageState();
}

class _ChildHomePageState extends State<ChildHomePage> {
  final List<String> mascotImages = [
    'assets/images/mascot_1.png',
    'assets/images/mascot_2.png',
    'assets/images/mascot_3.png',
  ];

  late String mascotImagePath;

  @override
  void initState() {
    super.initState();
    mascotImagePath = mascotImages[Random().nextInt(mascotImages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(mascotImagePath, width: 120),
          SizedBox(height: 10),
          Text('こんにちは！ポイントをチェックしよう！', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                mascotImagePath =
                    mascotImages[Random().nextInt(mascotImages.length)];
              });
            },
            child: Text('マスコット変更'),
          ),
        ],
      ),
    );
  }
}

class EarnPointPage extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> categories = {
    'お手伝い': [
      {'name': 'お皿洗い', 'icon': Icons.local_dining},
      {'name': 'お風呂掃除', 'icon': Icons.bathtub},
    ],
    '勉強': [
      {'name': '読書', 'icon': Icons.menu_book},
      {'name': '計算練習', 'icon': Icons.calculate},
    ],
  };

  void _submitTask(BuildContext context, String taskName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「$taskName」を申請しました'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );
    // 今後ここでDB登録や親への通知処理を追加予定
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(12),
      children: categories.entries.map((entry) {
        return ExpansionTile(
          title: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
          children: entry.value.map((task) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListTile(
                leading: Icon(task['icon'], size: 40, color: Colors.teal),
                title: Text(task['name'], style: TextStyle(fontSize: 18)),
                trailing: ElevatedButton(
                  onPressed: () => _submitTask(context, task['name']),
                  child: Text('しんせい'),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
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
