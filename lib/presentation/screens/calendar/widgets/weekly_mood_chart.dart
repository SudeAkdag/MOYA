import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'section_header.dart';
import 'mood_chart_painter.dart';

class WeeklyMoodChart extends StatelessWidget {
  final String mood;
  final String subtitle;

  const WeeklyMoodChart(
      {super.key, required this.mood, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Haftalık Ruh Hali', subtitle: subtitle),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: Size.infinite,
              painter: MoodChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
}
