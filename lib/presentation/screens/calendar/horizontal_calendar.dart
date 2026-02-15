import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moya/data/models/calendar_event_model.dart';

class HorizontalCalendar extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final List<CalendarEventModel> events;
  final ThemeData theme;

  const HorizontalCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.events,
    required this.theme,
  });

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Widget çizildikten sonra seçili güne kaydır.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
  }

  @override
  void didUpdateWidget(covariant HorizontalCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Eğer seçili gün veya ay değiştiyse, yeni seçili güne kaydır.
    if (!DateUtils.isSameDay(widget.selectedDay, oldWidget.selectedDay) ||
        widget.focusedDay.month != oldWidget.focusedDay.month) {
      _scrollToSelectedDay();
    }
  }

  void _scrollToSelectedDay() {
    if (!mounted) return;
    final dayIndex = widget.selectedDay.day - 1;
    // Her bir günün genişliği (56) + marjini (8) hesaba katarak ortalamaya çalışıyoruz.
    final targetOffset = (dayIndex * 64.0) - (context.size!.width / 2) + 32; 
    
    _scrollController.animateTo(
      targetOffset < 0 ? 0 : targetOffset, // Negatif değere gitmesini engelle
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(widget.focusedDay.year, widget.focusedDay.month);
    
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: daysInMonth,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(widget.focusedDay.year, widget.focusedDay.month, day);
          final isSelected = DateUtils.isSameDay(widget.selectedDay, date);
          final hasEvent = widget.events.any((event) => DateUtils.isSameDay(event.date, date));

          return GestureDetector(
            onTap: () => widget.onDaySelected(date),
            child: Container(
              width: 56,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? widget.theme.colorScheme.primary : widget.theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E('tr_TR').format(date).substring(0,1).toUpperCase(), // "P", "S", "Ç"
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? widget.theme.colorScheme.onPrimary.withOpacity(0.8) : widget.theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? widget.theme.colorScheme.onPrimary : widget.theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Olay varsa gösterilecek nokta
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: hasEvent 
                          ? (isSelected ? widget.theme.colorScheme.onPrimary : widget.theme.colorScheme.primary)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
