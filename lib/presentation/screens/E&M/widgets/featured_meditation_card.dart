import 'package:flutter/material.dart';

class FeaturedMeditationCard extends StatelessWidget {
  const FeaturedMeditationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuDb3WgufuxI9_vas7klPz4AruC9Y-8kqGAThestgHgSVVYH757JbT8mRxyYzjZwzIPEBcVl54XL4iwuA2Ug4LCBjL5DZnbE_UY-kXZaf05RL9RAyUC-yZHKg3CdKN1VkPh_mMjvYoj3kHP_LS5jJSix75q6HEwpPvFra5ut2vf5A_MGR95z9UlBV4ADqs0TTJQfvPY2V3_X4tXfeJNIMC-HgA_3YQAyb43xV_enrud5JTD93REilkMmRSP1NTGlQ_46TomZYHXaVSB6",
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.scaffoldBackgroundColor,
                        theme.scaffoldBackgroundColor.withOpacity(0.7),
                        Colors.transparent
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 14),
                            const SizedBox(width: 6),
                            Text("Sana Özel Öneri", style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onBackground)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("10 dk Odaklanma", style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 6),
                      Text(
                        "Sınav öncesi zihnini toparlamak için ideal bir seri.",
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.7)),
                        maxLines: 2,
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.play_circle, color: theme.colorScheme.onPrimary, size: 22),
                        label: Text("Hemen Başla", style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
