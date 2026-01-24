import 'package:flutter/material.dart';

class MoodSelector extends StatefulWidget {
  final Function(int) onMoodSelected;

  const MoodSelector({super.key, required this.onMoodSelected});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  int _selectedIndex = -1;

  // Mood renklerini sabit tutuyoruz çünkü bunlar duyguları temsil eder.
  // Ancak AppColors sildiğimiz için buraya doğrudan renkleri veya yeni sabitleri ekliyoruz.
  final List<Map<String, dynamic>> _moods = const [
    {'icon': Icons.sentiment_very_dissatisfied, 'label': 'Kötü', 'color': Color(0xFFEF5350)},
    {'icon': Icons.sentiment_dissatisfied, 'label': 'Gergin', 'color': Colors.orangeAccent},
    {'icon': Icons.sentiment_neutral, 'label': 'Nötr', 'color': Color(0xFFFFCA28)},
    {'icon': Icons.sentiment_satisfied, 'label': 'İyi', 'color': Colors.lightGreen},
    {'icon': Icons.sentiment_very_satisfied, 'label': 'Harika', 'color': Color(0xFF66BB6A)},
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Temaya erişim
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        // 2. Kart rengini temanın surface/card renginden alıyoruz
        color: theme.cardTheme.color, 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bugün nasıl hissediyorsun?",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              // Renk otomatik olarak temanın textColor'ından gelir
            ),
          ),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_moods.length, (index) {
              final isSelected = _selectedIndex == index;
              final moodColor = _moods[index]['color'] as Color;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onMoodSelected(index + 1); 
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? moodColor.withValues(alpha: 0.2) 
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected 
                        ? Border.all(color: moodColor, width: 2)
                        : null,
                  ),
                  child: Icon(
                    _moods[index]['icon'],
                    // Seçili değilse temanın ikincil yazı rengini kullanıyoruz
                    color: isSelected 
                        ? moodColor 
                        : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                    size: isSelected ? 36 : 30,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}