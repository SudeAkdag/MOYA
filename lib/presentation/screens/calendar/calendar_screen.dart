import 'package:flutter/material.dart';

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
  String _selectedDay = 'Çar'; // Default to Wednesday

  // Mock data for each day
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

    // Prevent going to a month before the initial month
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
        return _NoteEntrySheet(
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
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _SliverContent(
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

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      backgroundColor: theme.scaffoldBackgroundColor.withAlpha(217),
      elevation: 0,
      pinned: true,
      expandedHeight: 150.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Positioned(
              bottom: 90.0,
              left: 0,
              right: 0,
              child: _MonthSelector(
                selectedDate: _displayedMonth,
                onMonthChanged: _changeMonth,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: _HorizontalCalendarStrip(onDaySelected: _handleDaySelected),
      ),
    );
  }
}

// Content for the SliverList
class _SliverContent extends StatelessWidget {
  final Map<String, dynamic> dayData;
  final List<String>? notes;
  final VoidCallback onNoteButtonTap;
  final ValueChanged<int> onDeleteNote;

  const _SliverContent({
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
          _WeeklyMoodChart(
            mood: dayData['mood'],
            subtitle: dayData['moodSubtitle'],
          ),
          const SizedBox(height: 24),
          _StatisticsSection(
            mostFeltEmotion: dayData['mostFeltEmotion'],
            completedGoals: dayData['completedGoals'],
            averageEnergy: dayData['averageEnergy'],
          ),
          const SizedBox(height: 24),
          _DailyNoteButton(onTap: onNoteButtonTap),
          if (notes != null)
            ...notes!.asMap().entries.map((entry) {
              final index = entry.key;
              final note = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _NoteCard(
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

// --- Header Widgets ---

class _MonthSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<int> onMonthChanged;

  const _MonthSelector(
      {required this.selectedDate, required this.onMonthChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const monthNames = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    final dateString =
        '${monthNames[selectedDate.month - 1]} ${selectedDate.year}';

    final now = DateTime.now();
    final initialMonth = DateTime(now.year, now.month, 1);
    final canGoBack = selectedDate.isAfter(initialMonth);

    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon:
                Icon(Icons.chevron_left, color: theme.colorScheme.onBackground.withOpacity(0.7), size: 24),
            onPressed: canGoBack ? () => onMonthChanged(-1) : null,
            splashRadius: 20,
          ),
          Text(
            dateString, // Using dynamic date
            style: theme.textTheme.titleLarge,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right,
                color: theme.colorScheme.onBackground.withOpacity(0.7), size: 24),
            onPressed: () => onMonthChanged(1),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

class _HorizontalCalendarStrip extends StatefulWidget {
  final Function(String) onDaySelected;

  const _HorizontalCalendarStrip({required this.onDaySelected});

  @override
  _HorizontalCalendarStripState createState() =>
      _HorizontalCalendarStripState();
}

class _HorizontalCalendarStripState extends State<_HorizontalCalendarStrip> {
  String _selectedDay = 'Çar'; // Default selected day

  // Mock data
  final List<Map<String, Object?>> days = [
    {'day': 'Pzt', 'date': '16', 'moodColor': Colors.blue[400], 'active': false},
    {'day': 'Sal', 'date': '17', 'moodColor': Colors.teal[400], 'active': false},
    {'day': 'Çar', 'date': '18', 'moodColor': null, 'active': true},
    {'day': 'Per', 'date': '19', 'moodColor': Colors.purple[400], 'active': false},
    {'day': 'Cum', 'date': '20', 'moodColor': null, 'active': false},
    {'day': 'Cmt', 'date': '21', 'moodColor': null, 'active': false},
    {'day': 'Paz', 'date': '22', 'moodColor': null, 'active': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: days
              .map((day) => _DayItem(
                    day: day['day'] as String,
                    date: day['date'] as String,
                    moodColor: day['moodColor'] as Color?,
                    isActive: _selectedDay == day['day'],
                    onTap: () {
                      setState(() {
                        _selectedDay = day['day'] as String;
                      });
                      widget.onDaySelected(_selectedDay);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final String day;
  final String date;
  final Color? moodColor;
  final bool isActive;
  final VoidCallback onTap;

  const _DayItem({
    required this.day,
    required this.date,
    this.moodColor,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentBlue = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? accentBlue : theme.colorScheme.onBackground.withOpacity(0.54),
              )
            ),
            const SizedBox(height: 8),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isActive ? accentBlue : theme.colorScheme.onBackground.withAlpha(13),
                borderRadius: BorderRadius.circular(16),
                border: isActive
                    ? null
                    : Border.all(color: theme.colorScheme.onBackground.withAlpha(26)),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                            color: accentBlue.withAlpha(77),
                            blurRadius: 15,
                            offset: const Offset(0, 5))
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: moodColor ?? Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Body Widgets ---

class _WeeklyMoodChart extends StatelessWidget {
  final String mood;
  final String subtitle;

  const _WeeklyMoodChart({required this.mood, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Haftalık Ruh Hali', subtitle: subtitle),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: Size.infinite,
              painter: _MoodChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  final String mostFeltEmotion;
  final int completedGoals;
  final double averageEnergy;

  const _StatisticsSection({
    required this.mostFeltEmotion,
    required this.completedGoals,
    required this.averageEnergy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'İstatistiklerim'),
        const SizedBox(height: 16),
        _StatCard(
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
              child: _StatCard(
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
              child: _StatCard(
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

class _DailyNoteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DailyNoteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentBlue = theme.colorScheme.primary;

    return _GlassCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentBlue.withAlpha(26),
                  ),
                  child: Icon(Icons.edit_note, color: accentBlue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Günlük Not Ekle', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text('Bugün nasıl hissettiğini yaz...', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onBackground.withOpacity(0.3), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String note;
  final VoidCallback onDelete;
  const _NoteCard({required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notes_rounded, color: theme.colorScheme.onBackground.withOpacity(0.38), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              note,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon:
                const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
            onPressed: onDelete,
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          )
        ],
      ),
    );
  }
}

// --- Reusable Generic Widgets ---

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: theme.textTheme.titleMedium,
          ),
        ]
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.onBackground.withAlpha(26),
            theme.colorScheme.onBackground.withAlpha(13)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onBackground.withAlpha(26)),
      ),
      child: child,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool isLarge;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.subtitle,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: isLarge ? _buildLargeContent(context) : _buildSmallContent(context),
    );
  }

  Widget _buildLargeContent(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.38))),
            ]
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: iconBgColor),
          child: Icon(icon, color: iconColor, size: 28),
        ),
      ],
    );
  }

  Widget _buildSmallContent(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: iconBgColor,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: theme.textTheme.displaySmall,
            children: [
              TextSpan(text: value),
              if (subtitle != null)
                TextSpan(
                  text: subtitle,
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.38)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

// --- Chart Painter ---

class _MoodChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // This painter uses hardcoded colors for the chart itself.
    // Theming this chart would require more information on how the theme should affect it.
    // For now, we leave it as it is.
    final linePaint = Paint()
      ..color = const Color(0xFF38bdf8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final linePath = Path()
      ..moveTo(0, h * 0.75)
      ..cubicTo(
          w * 0.12, h * 0.75, w * 0.15, h * 0.25, w * 0.25, h * 0.375)
      ..cubicTo(
          w * 0.35, h * 0.5, w * 0.41, h * 0.1875, w * 0.5, h * 0.1875)
      ..cubicTo(
          w * 0.59, h * 0.1875, w * 0.65, h * 0.5625, w * 0.75, h * 0.5625)
      ..cubicTo(w * 0.85, h * 0.5625, w * 0.91, h * 0.125, w, h * 0.3125);

    canvas.drawPath(linePath, linePaint);

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF38bdf8).withAlpha(77),
          const Color(0xFF38bdf8).withAlpha(0)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final fillPath = Path.from(linePath)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NoteEntrySheet extends StatefulWidget {
  final String initialText;
  final ValueChanged<String> onSave;

  const _NoteEntrySheet({required this.initialText, required this.onSave});

  @override
  State<_NoteEntrySheet> createState() => _NoteEntrySheetState();
}

class _NoteEntrySheetState extends State<_NoteEntrySheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bugünün Notu',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                autofocus: true,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Bugün nasıl hissettiğini yaz...',
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.54)),
                  filled: true,
                  fillColor: theme.colorScheme.background.withAlpha(100),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => widget.onSave(_controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Kaydet',
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}