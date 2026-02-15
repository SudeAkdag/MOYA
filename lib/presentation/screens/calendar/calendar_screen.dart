import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moya/data/models/calendar_event_model.dart';
import 'package:moya/data/services/calendar_service.dart'; // Varsayılan olarak kalacak
import 'package:moya/presentation/screens/calendar/horizontal_calendar.dart';
import 'package:moya/presentation/screens/calendar/daily_note_screen.dart';
import 'package:fl_chart/fl_chart.dart'; // FlChart için gerekli

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  void _changeMonth(int increment) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + increment, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        bottom: false, // Alt navigasyon barı ile çakışmayı önlemek için
        child: StreamBuilder<List<CalendarEventModel>>(
          stream: CalendarService.getEventsForMonth(_focusedDay),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Veriler yüklenirken bir hata oluştu: ${snapshot.error}',
                    style: TextStyle(color: theme.colorScheme.onSurface)),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final events = snapshot.data ?? [];
            final weeklyMoods = _calculateWeeklyMoods(events, _selectedDay);

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
                  pinned: true,
                  expandedHeight: 150,
                  elevation: 0,
                  // Üst bar daraldığında başlıkta bir şey görünmemesi için.
                  title: const SizedBox.shrink(),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildMonthSelector(theme),
                          const SizedBox(height: 8),
                          HorizontalCalendar(
                            focusedDay: _focusedDay,
                            selectedDay: _selectedDay,
                            onDaySelected: _onDaySelected,
                            events: events, theme: theme,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildWeeklyMoodSection(theme, weeklyMoods),
                      _buildStatisticsSection(theme),
                      _buildDailyNoteButton(theme),
                      const SizedBox(height: 100), // For bottom nav space
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthSelector(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildNavButton(theme, Icons.chevron_left, () => _changeMonth(-1)),
        SizedBox(
          width: 150,
          child: Center(
            child: Text(
              DateFormat.yMMMM('tr_TR').format(_focusedDay),
              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        _buildNavButton(theme, Icons.chevron_right, () => _changeMonth(1)),
      ],
    );
  }

  Widget _buildNavButton(ThemeData theme, IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.7)),
        ),
      ),
    );
  }

  Map<int, double> _calculateWeeklyMoods(List<CalendarEventModel> monthEvents, DateTime selectedDay) {
    final Map<int, List<double>> moodByWeekday = {};
    final startOfWeek = DateUtils.dateOnly(selectedDay.subtract(Duration(days: selectedDay.weekday - 1)));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final weekEvents = monthEvents.where((event) {
      final eventDate = DateUtils.dateOnly(event.date);
      return (eventDate.isAtSameMomentAs(startOfWeek) || eventDate.isAfter(startOfWeek)) &&
          eventDate.isBefore(endOfWeek) &&
          event.mood != null;
    });

    for (var event in weekEvents) {
      moodByWeekday.putIfAbsent(event.date.weekday, () => []).add(event.mood!);
    }

    return moodByWeekday.map((key, value) => MapEntry(key, value.reduce((a, b) => a + b) / value.length));
  }


  LineChartData _moodChartData(ThemeData theme, Map<int, double> weeklyMoods) {
    List<FlSpot> spots = weeklyMoods.entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    spots.sort((a, b) => a.x.compareTo(b.x));

    final isSelectedDayInChart = spots.any((s) => s.x.toInt() == _selectedDay.weekday);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) { // Updated line style
          return const FlLine(color: Colors.white10, strokeWidth: 0.5);
        },
        drawVerticalLine: false, // Removed vertical lines
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1, // Added interval for better spacing
            getTitlesWidget: (double value, TitleMeta meta) {
              final isSelected = value.toInt() == _selectedDay.weekday;
              final style = TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              );
              String text = '';
              switch (value.toInt()) {
                case 1:
                  text = 'Pzt';
                  break;
                case 2:
                  text = 'Sal';
                  break;
                case 3:
                  text = 'Çar';
                  break;
                case 4:
                  text = 'Per';
                  break;
                case 5:
                  text = 'Cum';
                  break;
                case 6:
                  text = 'Cmt';
                  break;
                case 7:
                  text = 'Paz';
                  break;
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(text, style: style, textAlign: TextAlign.center),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Simplified left titles
      ),
      borderData: FlBorderData(show: false), // Removed border
      minX: 1,
      maxX: 7,
      minY: 1,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: theme.colorScheme.primary,
          barWidth: 3, // Adjusted bar width
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: theme.colorScheme.surface,
                strokeColor: theme.colorScheme.primary,
                strokeWidth: 2,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary.withOpacity(0.3), theme.colorScheme.primary.withOpacity(0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Pulsing dot for selected day
        if (isSelectedDayInChart)
          LineChartBarData(
            spots: [spots.firstWhere((s) => s.x.toInt() == _selectedDay.weekday)],
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 8,
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            color: Colors.transparent,
          ),
      ],
    );
  }

  Widget _buildWeeklyMoodSection(ThemeData theme, Map<int, double> weeklyMoods) {
    double averageMood = 0;
    if (weeklyMoods.isNotEmpty) {
      averageMood = weeklyMoods.values.reduce((a, b) => a + b) / weeklyMoods.length;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Haftalık Ruh Hali', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Duygu durumun bu hafta dengeli.', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 15)),
                ],
              ),
              // Placeholder for trend
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: theme.colorScheme.primary, size: 16),
                    const SizedBox(width: 4),
                    Text('+12%', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          _GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ORTALAMA MOOD', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                        Text(averageMood.toStringAsFixed(1), style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text('Mood', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8), fontSize: 12)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 160,
                  child: weeklyMoods.isNotEmpty
                      ? LineChart(_moodChartData(theme, weeklyMoods))
                      : Center(
                          child: Text(
                          'Bu haftaya ait ruh hali verisi bulunamadı.',
                          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                        )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('İstatistiklerim', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDominantEmotionCard(theme),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildGoalsCard(theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildEnergyCard(theme)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDominantEmotionCard(ThemeData theme) {
    return _GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('En Çok Hissettiğin Duygu', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 12)),
              const SizedBox(height: 4),
              Text('Kaygılı', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Son 7 günde 3 kez', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 12)),
            ],
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(Icons.sentiment_dissatisfied_outlined, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }

  Widget _buildGoalsCard(ThemeData theme) {
    return _GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.primary, child: const Icon(Icons.check_circle_outline, size: 20, color: Colors.white)),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: '12',
              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 28, fontWeight: FontWeight.bold),
              children: [TextSpan(text: '/15', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.normal))],
            ),
          ),
          const SizedBox(height: 4),
          Text('Tamamlanan Hedefler', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEnergyCard(ThemeData theme) {
    return _GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.primary, child: const Icon(Icons.bolt, size: 20, color: Colors.white)),
          const SizedBox(height: 16),
          Text('7.5', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Ortalama Enerjin', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDailyNoteButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Material(
        color: theme.colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DailyNoteScreen(selectedDate: _selectedDay),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(Icons.edit_note, color: theme.colorScheme.surface),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Günlük Not Ekle', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Bugün nasıl hissettiğini yaz...', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onSurface.withOpacity(0.4), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const _GlassCard({required this.child, this.padding, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.08),
        borderRadius: borderRadius ?? BorderRadius.circular(24), // rounded-3xl
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}