import 'package:flutter/material.dart';

class SmallMeditationCard extends StatelessWidget {
  const SmallMeditationCard({
    super.key,
    required this.title,
    required this.icon,
    required this.imageUrl,
  });
  final String title;
  final IconData icon;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.1))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.6)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.onBackground.withOpacity(0.05),
                      border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.1)),
                      ),
                      child: Center(child: Icon(icon, color: theme.colorScheme.onBackground))),
                  const SizedBox(height: 12),
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
