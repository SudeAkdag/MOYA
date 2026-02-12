import 'package:flutter/material.dart';

import 'section_header.dart';
import 'stat_card.dart';

class StatisticsSection extends StatelessWidget {
  final String mostFeltEmotion;
  final int completedGoals;
  final double averageEnergy;

  const StatisticsSection({
    super.key,
    required this.mostFeltEmotion,
    required this.completedGoals,
    required this.averageEnergy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'İstatistiklerim'),
        const SizedBox(height: 16),
        StatCard(
          title: 'En Çok Hissettiğin Duygu',
          value: mostFeltEmotion,
          subtitle: 'Son 7 günde 3 kez',
          icon: Icons.sentiment_dissatisfied,
          iconColor: Colors.indigo[300]!,
          iconBgColor: Colors.indigo.withAlpha(51),
          isLarge: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Tamamlanan Hedefler',
                value: completedGoals.toString(),
                subtitle: '/15',
                icon: Icons.check_circle,
                iconColor: Colors.green[400]!,
                iconBgColor: Colors.green.withAlpha(51),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Ortalama Enerjin',
                value: averageEnergy.toString(),
                icon: Icons.bolt,
                iconColor: Colors.yellow[400]!,
                iconBgColor: Colors.yellow.withAlpha(51),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
