import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/E&M/widgets/breathing_screen/breathing_technique_model.dart';

class BreathingTechniqueCard extends StatelessWidget {
  final BreathingTechnique technique;
  final bool isSelected;
  final VoidCallback onTap;

  const BreathingTechniqueCard({
    super.key,
    required this.technique,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? technique.color.withOpacity(0.2) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? technique.color : theme.colorScheme.onSurface.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(technique.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: technique.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      technique.tag.toUpperCase(),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(technique.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(technique.subtitle, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
