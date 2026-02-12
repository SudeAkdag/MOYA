import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyIntentionCard extends StatelessWidget {
  const DailyIntentionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onBackground.withAlpha(25)),
        gradient: LinearGradient(
          colors: [theme.colorScheme.surface, theme.colorScheme.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny_outlined, color: theme.primaryColor, size: 14),
              const SizedBox(width: 8),
              Text(
                'Günün Niyeti',
                style: textTheme.labelSmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"Bugün kontrol edemediğim şeyleri serbest bırakıyorum ve sadece kendi huzuruma odaklanıyorum."',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              textStyle: textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground.withAlpha(230),
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}