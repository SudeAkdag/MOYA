import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      
      body: Center(
        child: Text(
          "Egzersiz Sayfası",
          textAlign: TextAlign.center,
      
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            
            fontWeight: FontWeight.w500, 
          ),
        ),
      ),
    );
  }
}