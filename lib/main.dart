import 'package:flutter/material.dart';

void main() {
  runApp(HomeMoneyApp());
}

class HomeMoneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'うちマネ',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int balance = 100;

  void addPoint() {
    setState(() {
      balance += 10;
    });
    updatePhrase();
  }

  void usePoint() {
    setState(() {
      if (balance >= 10) balance -= 10;
    });
    updatePhrase();
  }

  final List<String> phrases = [
    'こんにちは！おこづかいをためようね！',
    'がんばったね！ポイントげっと！',
    'つぎはなにをかおうかな？',
    'いいね！いっぱいためてね！',
    'やったー！ぼくもうれしい！',
  ];

  String currentPhrase = '';
  void updatePhrase() {
    setState(() {
      phrases.shuffle();
      currentPhrase = phrases.first;
    });
  }

  @override
  void initState() {
    super.initState();
    updatePhrase(); // 初期セリフ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('うちマネ')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start, // ←ココ重要
            children: [
              Column(
                children: [
                  Image.asset('assets/images/mascot.png', width: 120),
                  SizedBox(height: 10),
                  Text(
                    currentPhrase,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('ざんだか：$balance ポイント', style: TextStyle(fontSize: 24)),
              SizedBox(height: 30),

              SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: addPoint,
                icon: Image.asset(
                  'assets/images/gift.png',
                  width: 40,
                  height: 40,
                ),
                label: Text('ポイントをもらう'),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: usePoint,
                icon: Image.asset(
                  'assets/images/cart.png',
                  width: 40,
                  height: 40,
                ),
                label: Text('ポイントをつかう'),
              ),
              SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('履歴はまだ未実装です')));
                },
                icon: Image.asset(
                  'assets/images/receipt.png',
                  width: 40,
                  height: 40,
                ),
                label: Text('履歴を見る'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
