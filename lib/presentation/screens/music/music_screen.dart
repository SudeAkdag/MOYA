import 'package:flutter/material.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Temaya erişim sağlıyoruz.
    final theme = Theme.of(context);

    return Scaffold(
      // Temiz Kod: Gereksiz backgroundColor atamasından kaçındık.
      body: Center(
        child: Text(
          "Müzik ve Sesler\n(Spotify benzeri liste)",
          textAlign: TextAlign.center,
          // 2. Uygulama genelindeki font ve renk tutarlılığı için theme kullanıyoruz.
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}