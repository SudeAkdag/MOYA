import 'package:flutter/material.dart';

import 'daily_note_button.dart';
import 'note_card.dart';
import 'statistics_section.dart';
import 'weekly_mood_chart.dart';

class SliverContent extends StatelessWidget {
  final Map<String, dynamic> dayData;
  final List<String>? notes;
  final VoidCallback onNoteButtonTap;
  final ValueChanged<int> onDeleteNote;

  const SliverContent({
    super.key,
    required this.dayData,
    this.notes,
    required this.onNoteButtonTap,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          WeeklyMoodChart(
            mood: dayData['mood'],
            subtitle: dayData['moodSubtitle'],
          ),
          const SizedBox(height: 24),
          StatisticsSection(
            mostFeltEmotion: dayData['mostFeltEmotion'],
            completedGoals: dayData['completedGoals'],
            averageEnergy: dayData['averageEnergy'],
          ),
          const SizedBox(height: 24),
          DailyNoteButton(onTap: onNoteButtonTap),
          if (notes != null)
            ...notes!.asMap().entries.map((entry) {
              final index = entry.key;
              final note = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: NoteCard(
                  note: note,
                  onDelete: () => onDeleteNote(index),
                ),
              );
            }),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
