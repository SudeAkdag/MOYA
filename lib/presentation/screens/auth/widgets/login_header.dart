import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(Icons.spa, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: 10),
        Text(
          "MOYA",
          style: theme.textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        Text(
          "İçindeki Huzuru Keşfet",
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white60),
        ),
      ],
    );
  }
}