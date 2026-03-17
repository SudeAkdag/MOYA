import 'package:flutter/material.dart';
import 'package:moya/data/services/database_service.dart';

class HomeMoodSelector extends StatefulWidget {
  const HomeMoodSelector({super.key});

  @override
  State<HomeMoodSelector> createState() => _HomeMoodSelectorState();
}

class _HomeMoodSelectorState extends State<HomeMoodSelector> {
  String _selectedMood = '';
  bool _isSaving = false; // Art arda basılmayı engellemek için eklendi

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😔', 'text': 'Tükenmiş', 'color': Colors.indigo, 'value': 2.0},
    {'emoji': '✨', 'text': 'Umutlu', 'color': Colors.yellow, 'value': 8.0},
    {'emoji': '😰', 'text': 'Kaygılı', 'color': Colors.purple, 'value': 4.0},
    {'emoji': '⚖️', 'text': 'Dengede', 'color': Colors.teal, 'value': 6.0},
    {'emoji': '😄', 'text': 'Mutlu', 'color': Colors.orange, 'value': 10.0},
    {'emoji': '😠', 'text': 'Kızgın', 'color': Colors.red, 'value': 3.0},
    {'emoji': '😥', 'text': 'Üzgün', 'color': Colors.blue, 'value': 3.0},
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
              onTap: () async {
                if (_isSaving) return; // Kayıt işlemi sürüyorsa tıklamayı yoksay

                setState(() {
                  _selectedMood = text;
                  _isSaving = true;
                });

                // LİNTER HATASINA KESİN ÇÖZÜM: 
                // Context'i 'await' kullanmadan ÖNCE güvenli bir değişkene alıyoruz
                final messenger = ScaffoldMessenger.of(context);

                // Veritabanına kaydet
                await DatabaseService.saveDailyMood(text, mood['emoji'], mood['value']);
                
                if (mounted) {
                  setState(() => _isSaving = false);
                }

                // Artık 'context' yerine 'messenger' kullandığımız için hata/uyarı vermez!
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Bugün $text hissediyorsun. Takvime işlendi! ✨'), 
                    duration: const Duration(seconds: 1)
                  ),
                );
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
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 100, // Genişliği sabitledik ki düzenli dursun
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : theme.colorScheme.onBackground.withAlpha(15),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected 
                      ? theme.colorScheme.onBackground 
                      : theme.colorScheme.onBackground.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}