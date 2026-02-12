import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<int> onMonthChanged;

  const MonthSelector(
      {super.key, required this.selectedDate, required this.onMonthChanged});

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
            icon: Icon(Icons.chevron_left,
                color: theme.colorScheme.onBackground.withOpacity(0.7),
                size: 24),
            onPressed: canGoBack ? () => onMonthChanged(-1) : null,
            splashRadius: 20,
          ),
          Text(
            dateString, // Using dynamic date
            style: theme.textTheme.titleLarge,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right,
                color: theme.colorScheme.onBackground.withOpacity(0.7),
                size: 24),
            onPressed: () => onMonthChanged(1),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
