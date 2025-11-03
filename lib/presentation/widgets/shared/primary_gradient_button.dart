import 'package:flutter/material.dart';
import 'package:flutter_basic_01/core/theme/app_colors.dart'; // 色定義をインポート

class PrimaryGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // 押せない状態 (null) も考慮

  const PrimaryGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: AppColors.primaryLight.withOpacity(0.5),
          elevation: 6,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryLight, // 👈 テーマの色
                AppColors.primary, // 👈 テーマの色
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textLight, // 👈 テーマの色
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
