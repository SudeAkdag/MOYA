import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

// Main Screen Widget
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _displayedMonth;
  late DateTime _selectedDayDate;
  final Map<DateTime, List<String>> _notes = {};
  String _selectedDay = 'Çar'; // Varsayılan gün

  // DÜZELTME: Sınıf içindeki değişkenler 'static const' değilse 'final' olmalıdır.
  final Color customGreen = const Color(0xFF636E3B); 
  final Color customCream = const Color(0xFFFFFBE6);

  // Veri Seti
  final Map<String, Map<String, dynamic>> _dayData = {
    'Pzt': {
      'mood': 'Mutlu',
      'moodSubtitle': 'Haftaya enerjik başladın!',
      'mostFeltEmotion': 'Neşeli',
      'completedGoals': 8,
      'averageEnergy': 8.2,
      'notes': ['Pazartesi notu 1', 'Pazartesi notu 2'],
    },
    'Sal': {
      'mood': 'Sakin',
      'moodSubtitle': 'Bugün oldukça dingindi.',
      'mostFeltEmotion': 'Huzurlu',
      'completedGoals': 10,
      'averageEnergy': 7.8,
      'notes': ['Salı için bir not.'],
    },
    'Çar': {
      'mood': 'Dengeli',
      'moodSubtitle': 'Duygu durumun bu hafta dengeli.',
      'mostFeltEmotion': 'Kaygılı',
      'completedGoals': 12,
      'averageEnergy': 7.5,
      'notes': [],
    },
    'Per': {
      'mood': 'Yorgun',
      'moodSubtitle': 'Biraz dinlenmeye ihtiyacın var gibi.',
      'mostFeltEmotion': 'Stresli',
      'completedGoals': 5,
      'averageEnergy': 4.5,
      'notes': ['Perşembe günü yapılacaklar...'],
    },
    'Cum': {
      'mood': 'Heyecanlı',
      'moodSubtitle': 'Hafta sonu planları hazır mı?',
      'mostFeltEmotion': 'Heyecanlı',
      'completedGoals': 14,
      'averageEnergy': 9.0,
      'notes': ['Cuma akşamı sinema!', 'Arkadaşlarla buluşulacak.'],
    },
    'Cmt': {
      'mood': 'Rahat',
      'moodSubtitle': 'Hafta sonunun tadını çıkar.',
      'mostFeltEmotion': 'Rahat',
      'completedGoals': 15,
      'averageEnergy': 8.8,
      'notes': [],
    },
    'Paz': {
      'mood': 'Huzurlu',
      'moodSubtitle': 'Yeni haftaya hazırlanıyorsun.',
      'mostFeltEmotion': 'Huzurlu',
      'completedGoals': 11,
      'averageEnergy': 7.0,
      'notes': ['Pazar sabahı kahvaltısı.'],
    },
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month, 1);
    _selectedDayDate = DateTime(now.year, now.month, now.day);
  }

  void _handleDaySelected(String day) {
    setState(() {
      _selectedDay = day;
    });
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  void _changeMonth(int increment) {
    final newMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + increment, 1);

    final now = DateTime.now();
    final initialMonth = DateTime(now.year, now.month, 1);
    if (newMonth.isBefore(initialMonth)) {
      return;
    }

    setState(() {
      _displayedMonth = newMonth;
    });
  }

  void _addNote(String text) {
    if (text.trim().isEmpty) return;
    final dayKey = _dateOnly(_selectedDayDate);
    setState(() {
      _notes[dayKey] = [...(_notes[dayKey] ?? []), text.trim()];
    });
  }

  void _deleteNote(int index) {
    final dayKey = _dateOnly(_selectedDayDate);
    setState(() {
      _notes[dayKey]?.removeAt(index);
      if (_notes[dayKey]?.isEmpty ?? false) {
        _notes.remove(dayKey);
      }
    });
  }

  void _showNoteEntry(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return NoteEntrySheet(
          initialText: "",
          onSave: (newText) {
            _addNote(newText);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentNotes = _notes[_dateOnly(_selectedDayDate)];
    final dayData = _dayData[_selectedDay]!;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: customCream,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, left: 24, bottom: 30),
              color: customGreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 45, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ayşe Yılmaz',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ayse.yilmaz@ornek.com',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _drawerItem(Icons.person_outline, 'Profil', () {}),
                  _drawerItem(Icons.self_improvement, 'Egzersiz ve Meditasyon', () {}),
                  _drawerItem(Icons.music_note, 'Müzik', () {}),
                  _drawerItem(Icons.description_outlined, 'Blog', () {}),
                  _drawerItem(Icons.bookmark_border, 'Kaydedilenler', () {}),
                  _drawerItem(Icons.settings_outlined, 'Ayarlar', () {}),
                  _drawerItem(Icons.info_outline, 'Hakkında', () {}),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  _drawerItem(Icons.logout, 'Çıkış Yap', () {}, color: Colors.redAccent),
                ],
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SliverContent(
                dayData: dayData,
                notes: currentNotes,
                onNoteButtonTap: () => _showNoteEntry(context),
                onDeleteNote: _deleteNote,
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap, {Color color = const Color(0xFF4A4A4A)}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      backgroundColor: theme.scaffoldBackgroundColor.withAlpha(217),
      elevation: 0,
      pinned: true,
      expandedHeight: 150.0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onBackground),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Positioned(
              bottom: 90.0,
              left: 0,
              right: 0,
              child: MonthSelector(
                selectedDate: _displayedMonth,
                onMonthChanged: _changeMonth,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: HorizontalCalendarStrip(onDaySelected: _handleDaySelected),
      ),
    );
  }
}