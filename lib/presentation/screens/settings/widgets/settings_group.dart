import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsGroup({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Temayı alıyoruz

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8, top: 24),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: theme.colorScheme.primary.withOpacity(0.7), // Başlık rengi ana renge uyumlu
              fontWeight: FontWeight.bold, 
              letterSpacing: 1.2, 
              fontSize: 12
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            // Kart rengini temanın yüzey (surface) renginden alıyoruz
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.2)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}