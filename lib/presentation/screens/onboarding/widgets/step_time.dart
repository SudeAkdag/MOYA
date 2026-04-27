import 'package:flutter/material.dart';

class StepTime extends StatefulWidget {
  final Map<String, dynamic> data;
  const StepTime({super.key, required this.data});

  @override
  State<StepTime> createState() => _StepTimeState();
}

class _StepTimeState extends State<StepTime> {
  // Liste düzeltildi: 'const' anahtarı 'sub' olarak değiştirildi.
  final List<Map<String, dynamic>> timeOptions = [
    {'title': '5-10 Dakika', 'sub': 'Hızlı ve etkili bir mola', 'icon': Icons.timer_outlined},
    {'title': '15-20 Dakika', 'sub': 'Derinlemesine odaklanma', 'icon': Icons.av_timer},
    {'title': '30+ Dakika', 'sub': 'Tam bir zihin tazeleme', 'icon': Icons.shutter_speed},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Günlük ne kadar vakit\nayırabilirsin?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Sana en uygun süreyi seçebilirsin",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        
        ...timeOptions.map((opt) {
          bool isSelected = widget.data['dailyTime'] == opt['title'];
          
          return Card(
            elevation: 0, 
            margin: const EdgeInsets.only(bottom: 12),
            color: isSelected 
                ? theme.primaryColor.withOpacity(0.1) 
                : Colors.white.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  opt['icon'] as IconData, 
                  color: theme.primaryColor
                ),
              ),
              title: Text(
                opt['title'] as String, 
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              subtitle: Text(opt['sub'] as String), // Artık null değil
              trailing: isSelected 
                  ? Icon(Icons.check_circle, color: theme.primaryColor) 
                  : null,
              onTap: () => setState(() {
                widget.data['dailyTime'] = opt['title'];
              }),
            ),
          );
        }),
      ],
    );
  }
}