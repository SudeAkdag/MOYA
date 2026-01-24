import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MoodSelector extends StatefulWidget {
  final Function(int) onMoodSelected; // Seçilen modu dışarı (Ana sayfaya) haber verir

  const MoodSelector({super.key, required this.onMoodSelected});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  int _selectedIndex = -1; // Başlangıçta hiçbiri seçili değil

  // Tasarımdaki 5 Duygu Durumu (Kötü -> İyi)
  final List<Map<String, dynamic>> _moods = [
    {'icon': Icons.sentiment_very_dissatisfied, 'label': 'Kötü', 'color': AppColors.moodBad},
    {'icon': Icons.sentiment_dissatisfied, 'label': 'Gergin', 'color': Colors.orangeAccent},
    {'icon': Icons.sentiment_neutral, 'label': 'Nötr', 'color': AppColors.moodNeutral},
    {'icon': Icons.sentiment_satisfied, 'label': 'İyi', 'color': Colors.lightGreen},
    {'icon': Icons.sentiment_very_satisfied, 'label': 'Harika', 'color': AppColors.moodGood},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor, // Kart rengi
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          const Text(
            "Bugün nasıl hissediyorsun?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // İkonlar Yan Yana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_moods.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  // Seçimi ana sayfaya bildir
                  widget.onMoodSelected(index + 1); 
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? _moods[index]['color'].withOpacity(0.2) 
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected 
                        ? Border.all(color: _moods[index]['color'], width: 2)
                        : null,
                  ),
                  child: Icon(
                    _moods[index]['icon'],
                    color: isSelected ? _moods[index]['color'] : Colors.grey,
                    size: isSelected ? 36 : 30, // Seçilince büyüsün
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