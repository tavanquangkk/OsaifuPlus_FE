import 'package:flutter/material.dart';
import 'package:flutter_basic_01/core/theme/app_themes.dart';
import 'package:flutter_basic_01/presentation/pages/startup_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Osaifu Plus',
      theme: AppTheme.lightTheme,
      home: StartupScreen(),
    );
  }
}
