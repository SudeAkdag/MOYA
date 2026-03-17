import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moya/data/services/database_service.dart';

class DailyIntentionCard extends StatelessWidget {
  const DailyIntentionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FutureBuilder<String>(
      future: DatabaseService.getDailyIntention(),
      builder: (context, snapshot) {
        String content = snapshot.data ?? "Bugün kendine nazik davranmayı unutma.";

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: theme.cardColor,
            border: Border.all(color: theme.colorScheme.onBackground.withAlpha(20)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            children: [
              Icon(Icons.format_quote, color: theme.primaryColor.withAlpha(100)),
              const SizedBox(height: 12),
              Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  textStyle: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withAlpha(200),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}