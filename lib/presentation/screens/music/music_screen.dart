import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Text(
          "Müzik ve Sesler\n(Spotify benzeri liste)",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}