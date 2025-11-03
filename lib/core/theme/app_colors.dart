import 'package:flutter/material.dart';

class AppColors {
  // これはプライベートコンストラクタで、インスタンス化を防ぎます
  AppColors._();

  // アプリの主要カラー
  static const Color primary = Color(0xFFF4511E); // 濃いめオレンジ
  static const Color primaryLight = Color(0xFFFF8A65); // サーモンオレンジ

  // 背景色
  static const Color background = Color.fromARGB(255, 254, 168, 106);

  // テキストカラー
  static const Color textPrimary = Color(0xFF424242);
  static const Color textLight = Colors.white;

  // その他の色
  static const Color grey = Colors.grey;
  static const Color white = Colors.white;
}
