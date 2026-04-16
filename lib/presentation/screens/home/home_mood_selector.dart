import 'package:flutter/material.dart';
import 'package:moya/data/services/database_service.dart'; // DatabaseService yolunu kendi projene göre ayarla
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeMoodSelector extends StatefulWidget {
  const HomeMoodSelector({super.key});

  @override
  State<HomeMoodSelector> createState() => _HomeMoodSelectorState();
}

class _HomeMoodSelectorState extends State<HomeMoodSelector> {
  String _selectedMood = '';
  bool _isLoading = true;

  // Grafiklerde kullanılabilmesi için emojilere 1-10 arası tahmini değerler atadık
  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😔', 'text': 'Tükenmiş', 'color': Colors.indigo },
    {'emoji': '✨', 'text': 'Umutlu', 'color': Colors.yellow},
    {'emoji': '😰', 'text': 'Kaygılı', 'color': Colors.purple },
    {'emoji': '⚖️', 'text': 'Dengede', 'color': Colors.teal },
    {'emoji': '😄', 'text': 'Mutlu', 'color': Colors.orange},
    {'emoji': '😠', 'text': 'Kızgın', 'color': Colors.red},
    {'emoji': '😥', 'text': 'Üzgün', 'color': Colors.blue},
  ];

  @override
  void initState() {
    super.initState();
    _fetchTodayMood();
  }

  /// Uygulama açıldığında bugünün verisini kontrol et
  Future<void> _fetchTodayMood() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final docId = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('calendar')
          .doc(docId)
          .get();

      if (doc.exists && doc.data() != null && doc.data()!.containsKey('moodText')) {
        setState(() {
          _selectedMood = doc.data()!['moodText'];
        });
      }
    } catch (e) {
      debugPrint("Ruh hali çekerken hata: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Kullanıcı tıkladığında hem arayüzü hem veritabanını günceller
  Future<void> _handleMoodSelection(Map<String, dynamic> mood) async {
    final text = mood['text'] as String;
    final emoji = mood['emoji'] as String;
   

    // Eğer aynı şeye tıkladıysa bir şey yapma
    if (_selectedMood == text) return;

    final isUpdate = _selectedMood.isNotEmpty;

    setState(() {
      _selectedMood = text;
    });

    // DatabaseService içerisindeki saveDailyMood fonksiyonunu çağırıyoruz
    await DatabaseService.saveDailyMood(text, emoji);

    // Eğer önceki bir seçim varsa, ekranda güncellendiğine dair bir mesaj göster
    if (isUpdate && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars(); // Üst üste binmesini engelle
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hissettiğin durum güncellendi: $emoji $text'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

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
              onTap: () => _handleMoodSelection(mood),
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
    
    // Projenin Krem ve Beyaz renk paletine uygun, sade bir arayüz stili
    return Material(
      color: isSelected ? color.withOpacity(0.15) : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: isSelected ? 0 : 1, // Seçili değilken hafif gölge
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.5) : theme.colorScheme.onSurface.withOpacity(0.05),
              width: isSelected ? 1.5 : 1.0,
            ),
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? color.withOpacity(0.9) : theme.colorScheme.onSurface.withOpacity(0.6),
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