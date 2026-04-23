import 'package:flutter/material.dart';

// section_header.dart içinde olması gereken yapı
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed; // Bu parametre önemli!

  const SectionHeader({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            if (onPressed != null)
              TextButton(
                onPressed: onPressed, // Burası tetikler
                child: const Text("Tümü", style: TextStyle(color: Colors.black)),
              ),
          ],
        ),
      ),
    );
  }
}