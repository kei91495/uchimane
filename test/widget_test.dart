import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchimane/main.dart';

void main() {
  testWidgets('RoleSelectScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RoleSelectScreen(), // ← ここが `MyApp()` ではない
      ),
    );

    // 「親として使う」「子どもとして使う」ボタンがあることを確認
    expect(find.text('親として使う'), findsOneWidget);
    expect(find.text('子どもとして使う'), findsOneWidget);
  });
}
