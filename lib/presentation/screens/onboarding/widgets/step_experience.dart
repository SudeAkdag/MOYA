import 'package:flutter/material.dart';

class StepExperience extends StatefulWidget {
  final Map<String, dynamic> data;
  const StepExperience({super.key, required this.data});

  @override
  State<StepExperience> createState() => _StepExperienceState();
}

class _StepExperienceState extends State<StepExperience> {
  final options = [
    {
      't': 'Hiç Denemedim',
      's': 'Sıfırdan başlamak için harika bir yerdesin.',
      'i': Icons.star_outline
    },
    {
      't': 'Biraz Bilgim Var',
      's': 'Temel kavramları biliyorum, derinleşmek istiyorum.',
      'i': Icons.auto_awesome_outlined
    },
    {
      't': 'Düzenli Uyguluyorum',
      's': 'Zaten bir pratiğim var, yeni teknikler arıyorum.',
      'i': Icons.self_improvement
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Daha önce meditasyon\nveya nefes egzersizi\ndeneyiminin oldu mu?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Sana en uygun olanı seçebilirsin",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        
        // Seçenekler listesi
        ...options.map((opt) {
          bool isSelected = widget.data['experienceLevel'] == opt['t'];

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
                  opt['i'] as IconData, 
                  color: theme.primaryColor
                ),
              ),
              title: Text(
                opt['t'] as String, 
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              subtitle: Text(opt['s'] as String),
              trailing: isSelected 
                  ? Icon(Icons.check_circle, color: theme.primaryColor) 
                  : null,
              onTap: () => setState(() {
                widget.data['experienceLevel'] = opt['t'];
              }),
            ),
          );
        }),
      ],
    );
  }
}