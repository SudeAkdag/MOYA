
import 'package:flutter/material.dart';

class StepReasons extends StatefulWidget {
  final Map<String, dynamic> data;
  const StepReasons({super.key, required this.data});

  @override
  State<StepReasons> createState() => _StepReasonsState();
}

class _StepReasonsState extends State<StepReasons> {
  final options = [
    {'title': 'Stres & Kaygı', 'sub': 'Zihnini sakinleştir', 'icon': Icons.air},
    {'title': 'Odaklanma', 'sub': 'Dikkatini güçlendir', 'icon': Icons.center_focus_strong},
    {'title': 'Uyku Kalitesi', 'sub': 'Derin ve huzurlu uyku', 'icon': Icons.bedtime},
    {'title': 'Motivasyon', 'sub': 'Enerjini yükselt', 'icon': Icons.bolt},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Seni MOYA'ya getiren\ntemel sebepler neler?", 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Birden fazla seçebilirsin", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        
        // Seçenekler listesi
        ...options.map((opt) {
          bool isSelected = widget.data['selectedGoals'].contains(opt['title']);
          return Card(
            elevation: 0, // Daha temiz bir görünüm için
            color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white, 
                child: Icon(opt['icon'] as IconData, color: Theme.of(context).primaryColor)
              ),
              title: Text(opt['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(opt['sub'] as String),
              onTap: () => setState(() {
                isSelected 
                  ? widget.data['selectedGoals'].remove(opt['title']) 
                  : widget.data['selectedGoals'].add(opt['title']);
              }),
            ),
          );
        }),
      ],
    );
  }
}