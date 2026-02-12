import 'package:flutter/material.dart';

class HomeMoodSelector extends StatefulWidget {
  const HomeMoodSelector({super.key});

  @override
  State<HomeMoodSelector> createState() => _HomeMoodSelectorState();
}

class _HomeMoodSelectorState extends State<HomeMoodSelector> {
  String _selectedMood = 'Dengede';

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😔', 'text': 'Tükenmiş', 'color': Colors.indigo},
    {'emoji': '✨', 'text': 'Umutlu', 'color': Colors.yellow},
    {'emoji': '😰', 'text': 'Kaygılı', 'color': Colors.purple},
    {'emoji': '⚖️', 'text': 'Dengede', 'color': Colors.teal},
    {'emoji': '😄', 'text': 'Mutlu', 'color': Colors.orange},
    {'emoji': '😠', 'text': 'Kızgın', 'color': Colors.red},
    {'emoji': '😥', 'text': 'Üzgün', 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_moods.length, (index) {
          final mood = _moods[index];
          final text = mood['text'] as String;
          return Padding(
            padding: EdgeInsets.only(right: index == _moods.length - 1 ? 0 : 12),
            child: _MoodOption(
              emoji: mood['emoji'] as String,
              text: text,
              color: mood['color'] as Color,
              isSelected: _selectedMood == text,
              onTap: () {
                setState(() {
                  _selectedMood = text;
                });
              },
            ),
          );
        }),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  const _MoodOption({
    required this.emoji,
    required this.text,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String text;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isSelected ? color.withAlpha(51) : theme.cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? color : theme.colorScheme.onBackground.withAlpha(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? theme.colorScheme.onBackground : theme.colorScheme.onBackground.withOpacity(0.7),
                    fontSize: 12,
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