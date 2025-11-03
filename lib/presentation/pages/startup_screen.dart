import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic_01/presentation/pages/auth/register_page.dart';
import 'package:flutter_basic_01/presentation/widgets/others/wave_clipper.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 168, 106),
      body: Stack(
        children: [
          // wave part
          Column(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  child: Image.asset(
                    "assets/images/bg-image.png",
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          ),
          // title and description
          Positioned(
            left: 0,
            right: 0,
            bottom: 200,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Osaifu Plus",
                    style: TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Osaifu Plusで今日からスマート家計管理",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("次へ", style: TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_circle_right,
                      size: 50,
                      color: const Color.fromARGB(255, 219, 58, 77),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
