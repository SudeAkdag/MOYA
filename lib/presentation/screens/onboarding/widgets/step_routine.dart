import 'package:flutter/material.dart';

class StepRoutine extends StatefulWidget {
  final Map<String, dynamic> data;
  const StepRoutine({super.key, required this.data});

  @override
  State<StepRoutine> createState() => _StepRoutineState();
}

class _StepRoutineState extends State<StepRoutine> {
  // HATA BURADAYDI: List tipini dynamic yaparak IconData kullanımına izin verdik.
  final List<Map<String, dynamic>> routines = [
    {'t': 'Sabah meditasyonu', 's': 'Güne huzurla başla', 'i': Icons.wb_sunny_outlined},
    {'t': 'Nefes egzersizi', 's': 'Stresi anında azalt', 'i': Icons.air},
    {'t': 'Günlük niyet', 's': 'Her güne bir niyet belirle', 'i': Icons.edit_note_outlined},
    {'t': 'Şükran günlüğü', 's': 'Güzel anlara odaklan', 'i': Icons.favorite_border},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Günlük rutinine ne\neklemek istersin?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Birden fazla seçebilirsin",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: routines.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final item = routines[index];
              bool isSelected = widget.data['routines'].contains(item['t']);

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
                      item['i'] as IconData, // Artık güvenle cast edilebilir
                      color: theme.primaryColor,
                    ),
                  ),
                  title: Text(
                    item['t']!, 
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                  subtitle: Text(item['s']!),
                  trailing: isSelected 
                      ? Icon(Icons.check_circle, color: theme.primaryColor)
                      : const Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        widget.data['routines'].remove(item['t']);
                      } else {
                        widget.data['routines'].add(item['t']);
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}