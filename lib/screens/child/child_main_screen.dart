import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../role_select_screen.dart';

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
  int currentPoint = 120; // 仮の所持ポイント
  int nextGoalPoint = 200; // 目標ポイント（例）

  @override
  void initState() {
    super.initState();
    mascotImagePath = mascotImages[Random().nextInt(mascotImages.length)];
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentPoint / nextGoalPoint;
    int remain = (nextGoalPoint - currentPoint).clamp(0, nextGoalPoint);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text(
            'いまのポイント',
            style: TextStyle(fontSize: 20, color: Colors.grey[700]),
          ),
          Text(
            '$currentPoint pt',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 20),
          Text('次の目標まで あと $remain pt'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          ),
          SizedBox(height: 20),
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class EarnPointPage extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> categories = {
    'お手伝い': [
      {'name': 'お皿洗い', 'icon': Icons.local_dining},
      {'name': '料理', 'icon': Icons.food_bank},
      {'name': 'お風呂掃除', 'icon': Icons.bathtub},
      {'name': 'おつかい', 'icon': Icons.shopping_bag},
    ],
    '勉強': [
      {'name': '読書', 'icon': Icons.menu_book},
      {'name': '計算練習', 'icon': Icons.calculate},
      {'name': '英語練習', 'icon': Icons.language},
      {'name': 'プログラミング', 'icon': Icons.laptop},
    ],
    'その他': [
      {'name': '早起き', 'icon': Icons.sunny},
      {'name': '早寝', 'icon': Icons.bedtime},
    ],
  };

  void _submitTask(BuildContext context, String taskName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「$taskName」をしんせいしました'),
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
          leading: Icon(_getCategoryIcon(entry.key), color: Colors.teal),
          title: Text(
            entry.key,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
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

IconData _getCategoryIcon(String category) {
  switch (category) {
    case 'お手伝い':
      return Icons.cleaning_services;
    case '勉強':
      return Icons.school;
    default:
      return Icons.category;
  }
}

class SpendPointPage extends StatelessWidget {
  final int currentPoints = 150; // 仮値、DBやshared_preferencesで取得する予定
  final String goalName = 'Switch Lite';
  final int goalPoints = 500;

  @override
  Widget build(BuildContext context) {
    final int remainingPoints = goalPoints - currentPoints;
    final double progress = currentPoints / goalPoints;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 目標：$goalName（${goalPoints}ポイント）',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
          SizedBox(height: 8),
          Text(
            remainingPoints > 0 ? 'あと $remainingPoints ポイントで達成！' : '🎉 達成しました！',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          Expanded(child: Center(child: Text('ここに使えるアイテム一覧などを表示'))),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history = [
    {'date': '2025-06-29', 'type': 'earn', 'detail': 'お皿洗い', 'amount': 50},
    {
      'date': '2025-06-29',
      'type': 'spend',
      'detail': '30分ゲーム時間',
      'amount': -100,
    },
    {'date': '2025-06-28', 'type': 'earn', 'detail': '計算練習', 'amount': 30},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(12),
      children: history.map((item) {
        final isEarn = item['type'] == 'earn';
        return Card(
          child: ListTile(
            leading: Icon(
              isEarn ? Icons.add_circle : Icons.remove_circle,
              color: isEarn ? Colors.green : Colors.red,
              size: 32,
            ),
            title: Text(item['detail']),
            subtitle: Text(item['date']),
            trailing: Text(
              '${isEarn ? '+' : ''}${item['amount']}pt',
              style: TextStyle(
                color: isEarn ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
