import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Text(
          "Meditasyon Sayfası\n(Nefes Egzersizleri)",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}