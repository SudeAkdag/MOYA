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
        // Veri yüklenirken veya hata durumunda görünecek varsayılan metin
        String content = snapshot.data ?? "Kendine nazik davranmayı unutma.";

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            // Resimdeki o tatlı mor/pembe tonu için temanın surface rengini veya 
            // direkt hafif bir mor tonu kullanabilirsin.
            color: theme.colorScheme.primaryContainer.withOpacity(0.4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tırnak işareti ikonu
              Opacity(
                opacity: 0.5,
                child: Icon(
                  Icons.format_quote_rounded, 
                  color: theme.colorScheme.primary, 
                  size: 32
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  textStyle: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
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