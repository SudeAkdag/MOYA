import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moya/data/models/calendar_event_model.dart';
import 'package:moya/data/services/calendar_service.dart';
import 'package:moya/presentation/screens/calendar/horizontal_calendar.dart';
import 'package:moya/presentation/screens/calendar/daily_note_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moya/presentation/widgets/profile_drawer_button.dart';

class CalendarScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const CalendarScreen({super.key, required this.onMenuTap});

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: ProfileDrawerButton(onPressed: widget.onMenuTap),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<List<CalendarEventModel>>(
          stream: CalendarService.getEventsForMonth(_focusedDay),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Veriler yüklenirken bir hata oluştu: ${snapshot.error}',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final events = snapshot.data ?? [];
            final weeklyMoods = _calculateWeeklyMoods(events, _selectedDay);
            final dominantMoodData = _calculateDominantMood(events, _selectedDay);
            final averageEnergy = _calculateAverageEnergy(events, _selectedDay);

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
                  pinned: true,
                  expandedHeight: 180,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: const SizedBox.shrink(),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border(
                          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildMonthSelector(theme),
                          const SizedBox(height: 12),
                          HorizontalCalendar(
                            focusedDay: _focusedDay,
                            selectedDay: _selectedDay,
                            onDaySelected: _onDaySelected,
                            events: events,
                            theme: theme,
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
                      _buildStatisticsSection(theme, dominantMoodData, averageEnergy),
                      _buildDailyNoteButton(theme),
                      const SizedBox(height: 100),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavButton(theme, Icons.chevron_left, () => _changeMonth(-1)),
          Text(
            DateFormat.yMMMM('tr_TR').format(_focusedDay),
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildNavButton(theme, Icons.chevron_right, () => _changeMonth(1)),
        ],
      ),
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

  Map<String, dynamic> _calculateDominantMood(List<CalendarEventModel> events, DateTime selectedDay) {
    final sevenDaysAgo = selectedDay.subtract(const Duration(days: 7));

    final recentEvents = events.where((e) {
      final eventDate = DateUtils.dateOnly(e.date);
      return eventDate.isAfter(sevenDaysAgo) &&
          (eventDate.isBefore(selectedDay) || eventDate.isAtSameMomentAs(selectedDay)) &&
          e.moodText != null;
    }).toList();

    if (recentEvents.isEmpty) {
      return {'moodText': 'Belirsiz', 'count': 0, 'emoji': '😶'};
    }

    final Map<String, int> moodCounts = {};
    final Map<String, String> moodEmojis = {};

    for (var event in recentEvents) {
      final text = event.moodText!;
      moodCounts[text] = (moodCounts[text] ?? 0) + 1;
      if (event.emoji != null) moodEmojis[text] = event.emoji!;
    }

    String dominantMood = '';
    int maxCount = 0;

    moodCounts.forEach((key, value) {
      if (value > maxCount) {
        maxCount = value;
        dominantMood = key;
      }
    });

    return {
      'moodText': dominantMood,
      'count': maxCount,
      'emoji': moodEmojis[dominantMood] ?? '✨',
    };
  }

  String _calculateAverageEnergy(List<CalendarEventModel> events, DateTime selectedDay) {
    final sevenDaysAgo = selectedDay.subtract(const Duration(days: 7));

    final recentEvents = events.where((e) {
      final eventDate = DateUtils.dateOnly(e.date);
      return eventDate.isAfter(sevenDaysAgo) &&
          (eventDate.isBefore(selectedDay) || eventDate.isAtSameMomentAs(selectedDay)) &&
          e.energy != null;
    }).toList();

    if (recentEvents.isEmpty) return "-";

    double totalEnergy = 0;
    for (var event in recentEvents) {
      totalEnergy += event.energy!;
    }

    final average = totalEnergy / recentEvents.length;
    return average.toStringAsFixed(1);
  }

  String _weekdayLabelTr(int weekday) {
    switch (weekday) {
      case 1:
        return 'Pzt';
      case 2:
        return 'Sal';
      case 3:
        return 'Çar';
      case 4:
        return 'Per';
      case 5:
        return 'Cum';
      case 6:
        return 'Cmt';
      case 7:
        return 'Paz';
      default:
        return '';
    }
  }

  LineChartData _moodChartData(ThemeData theme, Map<int, double> weeklyMoods) {
    final entries = weeklyMoods.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    final spots = entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

  
    double minY = 1;
    double maxY = 10;
    if (spots.isNotEmpty) {
      final ys = spots.map((s) => s.y).toList()..sort();
      final rawMin = ys.first;
      final rawMax = ys.last;
      final pad = ((rawMax - rawMin) * 0.25).clamp(0.8, 2.0);
      minY = (rawMin - pad).clamp(1.0, 10.0);
      maxY = (rawMax + pad).clamp(1.0, 10.0);
      if ((maxY - minY) < 2) {
        minY = (minY - 1).clamp(1.0, 10.0);
        maxY = (maxY + 1).clamp(1.0, 10.0);
      }
    }

    final lineGradient = LinearGradient(
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.primary.withOpacity(0.55),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          tooltipMargin: 12,
         getTooltipColor: (touchedSpot) => theme.colorScheme.surface.withOpacity(0.95),
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (touchedSpots) {
            // Tek seri olduğu için artık duplicate yazmaz
            return touchedSpots.map((t) {
              final day = _weekdayLabelTr(t.x.toInt());
              return LineTooltipItem(
                '$day\n${t.y.toStringAsFixed(1)}',
                TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  height: 1.2,
                ),
              );
            }).toList();
          },
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: theme.colorScheme.primary.withOpacity(0.20),
                strokeWidth: 2,
                dashArray: const [6, 6],
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 6.5,
                  color: theme.colorScheme.surface,
                  strokeColor: theme.colorScheme.primary,
                  strokeWidth: 2.5,
                ),
              ),
            );
          }).toList();
        },
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 2,
        getDrawingHorizontalLine: (value) => FlLine(
          color: theme.colorScheme.onSurface.withOpacity(0.08),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final isSelected = value.toInt() == _selectedDay.weekday;
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _weekdayLabelTr(value.toInt()),
                  style: TextStyle(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.55),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 1,
      maxX: 7,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          gradient: lineGradient,
          barWidth: 3.2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              final isSelected = spot.x.toInt() == _selectedDay.weekday;

              // seçili gün: büyük ve net nokta
              if (isSelected) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: theme.colorScheme.surface,
                  strokeColor: theme.colorScheme.primary,
                  strokeWidth: 2.6,
                );
              }

              // diğer günlerde nokta gösterme (daha temiz)
              return FlDotCirclePainter(
                radius: 0,
                color: Colors.transparent,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            // buğulu alanı yumuşattık (istersen show: false yap)
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.10),
                theme.colorScheme.primary.withOpacity(0.00),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
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
                  Text(
                    'Haftalık Ruh Hali',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                
                ],
              ),
           
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
                        Text(
                          'ORTALAMA MOOD',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          averageMood.toStringAsFixed(1),
                          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
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
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(ThemeData theme, Map<String, dynamic> dominantMoodData, String averageEnergy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('İstatistiklerim', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDominantEmotionCard(theme, dominantMoodData),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildGoalsCard(theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildEnergyCard(theme, averageEnergy)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDominantEmotionCard(ThemeData theme, Map<String, dynamic> data) {
    // ÇÖZÜM: '??' operatörü ile null olma durumuna karşı varsayılan değerler atadık.
    // data['moodText'] null gelirse sağındaki 'Belirsiz' yazısı kullanılır.
    final String moodName = data['moodText'] ?? 'Belirsiz'; 
    final int count = data['count'] ?? 0;
    final String emoji = data['emoji'] ?? '🤷';

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
              Text(moodName, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                count > 0 ? 'Son 7 günde $count kez' : 'Henüz kayıt yok',
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 12),
              ),
            ],
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
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
              children: [
                TextSpan(
                  text: '/15',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text('Tamamlanan Hedefler', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEnergyCard(ThemeData theme, String averageEnergy) {
    return _GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.primary, child: const Icon(Icons.bolt, size: 20, color: Colors.white)),
          const SizedBox(height: 16),
          Text(averageEnergy, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 28, fontWeight: FontWeight.bold)),
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
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}