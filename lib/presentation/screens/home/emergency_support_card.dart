import 'package:flutter/material.dart';

class EmergencySupportCard extends StatelessWidget {
  const EmergencySupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.error.withAlpha(25),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.error.withAlpha(77)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.support_agent, color: theme.colorScheme.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Acil Destek', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Birileriyle konuşmaya ihtiyacım var', style: TextStyle(color: theme.colorScheme.error, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: theme.colorScheme.error.withAlpha(102), size: 14),
            ],
          ),
        ),
      ),
    );
  }
}