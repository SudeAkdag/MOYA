import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = [
      {'icon': Icons.school, 'label': "Sınav Kaygısı", 'color': theme.colorScheme.primaryContainer},
      {'icon': Icons.bedtime, 'label': "Uykuya Hazırlık", 'color': theme.colorScheme.secondaryContainer},
      {'icon': Icons.wb_sunny, 'label': "Sabah Enerjisi", 'color': theme.colorScheme.tertiaryContainer},
      {'icon': Icons.more_horiz, 'label': "Diğer", 'color': theme.colorScheme.surfaceVariant},
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            final category = categories[index];
            final color = category['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.2),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Icon(category['icon'] as IconData, color: color, size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(category['label'] as String, style: theme.textTheme.bodySmall),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
