import 'package:flutter/material.dart';

class MoodHistorySection extends StatelessWidget {
  const MoodHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ruh Hali Geçmişi', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('Tümünü Gör')),
          ],
        ),
        Container(
          height: 150,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: theme.cardTheme.color, borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MoodBar(day: 'Pzt', heightFactor: 0.4),
              _MoodBar(day: 'Sal', heightFactor: 0.6),
              _MoodBar(day: 'Çar', heightFactor: 0.8, isToday: true),
              _MoodBar(day: 'Per', heightFactor: 0.5),
              _MoodBar(day: 'Cum', heightFactor: 0.3),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoodBar extends StatelessWidget {
  final String day;
  final double heightFactor;
  final bool isToday;

  const _MoodBar({required this.day, required this.heightFactor, this.isToday = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: FractionallySizedBox(
            heightFactor: heightFactor,
            child: Container(
              width: 12,
              decoration: BoxDecoration(
                color: isToday ? theme.primaryColor : theme.primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(color: isToday ? theme.primaryColor : null, fontSize: 10)),
      ],
    );
  }
}