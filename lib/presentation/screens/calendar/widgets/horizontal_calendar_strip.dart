import 'package:flutter/material.dart';

class HorizontalCalendarStrip extends StatefulWidget {
  final Function(String) onDaySelected;

  const HorizontalCalendarStrip({super.key, required this.onDaySelected});

  @override
  HorizontalCalendarStripState createState() => HorizontalCalendarStripState();
}

class HorizontalCalendarStripState extends State<HorizontalCalendarStrip> {
  String _selectedDay = 'Çar'; // Default selected day

  // Mock data
  final List<Map<String, Object?>> days = [
    {
      'day': 'Pzt',
      'date': '16',
      'moodColor': Colors.blue[400],
      'active': false
    },
    {
      'day': 'Sal',
      'date': '17',
      'moodColor': Colors.teal[400],
      'active': false
    },
    {'day': 'Çar', 'date': '18', 'moodColor': null, 'active': true},
    {
      'day': 'Per',
      'date': '19',
      'moodColor': Colors.purple[400],
      'active': false
    },
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
              .map((day) => DayItem(
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

class DayItem extends StatelessWidget {
  final String day;
  final String date;
  final Color? moodColor;
  final bool isActive;
  final VoidCallback onTap;

  const DayItem({
    super.key,
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
            Text(day.toUpperCase(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive
                      ? accentBlue
                      : theme.colorScheme.onBackground.withOpacity(0.54),
                )),
            const SizedBox(height: 8),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isActive
                    ? accentBlue
                    : theme.colorScheme.onBackground.withAlpha(13),
                borderRadius: BorderRadius.circular(16),
                border: isActive
                    ? null
                    : Border.all(
                        color: theme.colorScheme.onBackground.withAlpha(26)),
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
                      color: isActive
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onBackground,
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
