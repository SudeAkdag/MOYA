import 'package:flutter/material.dart';

import 'glass_card.dart';

class DailyNoteButton extends StatelessWidget {
  final VoidCallback onTap;
  const DailyNoteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentBlue = theme.colorScheme.primary;

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentBlue.withAlpha(26),
                  ),
                  child: Icon(Icons.edit_note, color: accentBlue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Günlük Not Ekle',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text('Bugün nasıl hissettiğini yaz...',
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: theme.colorScheme.onBackground.withOpacity(0.3),
                    size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
