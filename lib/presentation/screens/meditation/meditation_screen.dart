import 'package:flutter/material.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Temaya erişim sağlıyoruz.
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor'ı sildik; Scaffold varsayılan olarak theme.scaffoldBackgroundColor'ı kullanır.
      body: Center(
        child: Text(
          "Meditasyon Sayfası\n(Nefes Egzersizleri)",
          textAlign: TextAlign.center,
          // 2. Metin stilini temadaki başlık yapısına göre ayarlıyoruz.
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            // Renk otomatik olarak AppThemes içindeki textColor'dan gelir.
          ),
        ),
      ),
    );
  }
}