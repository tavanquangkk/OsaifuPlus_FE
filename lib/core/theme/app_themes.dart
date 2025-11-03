import 'package:flutter/material.dart';
import 'package:flutter_basic_01/core/theme/app_colors.dart'; // さっき作ったファイルをインポート

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      // 1. カラースキーム（色のセット）
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary, // メインの色
        brightness: Brightness.light,
        background: AppColors.background, // Scaffoldのデフォルト背景色
      ),

      // 2. フォント
      fontFamily: 'NotoSansJP', // (例: pubspec.yamlに設定した場合)
      // 3. AppBarのテーマ
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),

      // 4. Textのテーマ (特定のスタイルを共通化)
      textTheme: TextTheme(
        // 「新規登録」などの大きなタイトル用
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        // 「メール」などのラベル用
        bodyMedium: TextStyle(color: AppColors.textPrimary, fontSize: 16),
      ),

      // 5. TextButtonのテーマ
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary, // リンク色
        ),
      ),

      // 6. TextFormField (InputDecoration) のテーマ
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // 枠線なし
        ),
        filled: true,
        fillColor: AppColors.white.withOpacity(0.7), // 少し透明な白
        hintStyle: TextStyle(color: AppColors.grey),
      ),
    );
  }
}
