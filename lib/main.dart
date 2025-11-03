import 'package:flutter/material.dart';
import 'package:flutter_basic_01/core/theme/app_themes.dart';
import 'package:flutter_basic_01/presentation/pages/startup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Osaifu Plus',
      theme: AppTheme.lightTheme, // 👈 ここでテーマを適用
      // darkTheme: AppTheme.darkTheme, // (ダークモードも同様に定義可能)
      home: StartupScreen(), // 最初の画面
    );
  }
}
