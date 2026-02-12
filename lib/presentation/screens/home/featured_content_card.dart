import 'dart:ui';
import 'package:flutter/material.dart';

class FeaturedContentCard extends StatelessWidget {
  const FeaturedContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Senin İçin Seçtiklerimiz', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.primaryColor.withAlpha(51)),
              ),
              child: Row(
                children: [
                  Icon(Icons.smart_toy, size: 12, color: theme.primaryColor),
                  const SizedBox(width: 4),
                  Text('AI ÖNERİSİ', style: textTheme.labelSmall?.copyWith(fontSize: 10, color: theme.primaryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.colorScheme.onBackground.withAlpha(12)),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 20, spreadRadius: -10)],
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [theme.scaffoldBackgroundColor, theme.scaffoldBackgroundColor.withAlpha(0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onBackground.withAlpha(25),
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.onBackground.withAlpha(51)),
                        ),
                        child: Icon(Icons.play_arrow, color: theme.colorScheme.onBackground),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          _Tag('ODAKLANMA'),
                          SizedBox(width: 8),
                          _Tag('NEFES'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Zihinsel Arınma', style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: theme.colorScheme.onBackground.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text('3 dk Kutu Nefesi', style: textTheme.bodySmall),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.onBackground.withAlpha(25),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: theme.colorScheme.onBackground.withAlpha(25)),
          ),
          child: Text(label, style: theme.textTheme.labelSmall),
        ),
      ),
    );
  }
}