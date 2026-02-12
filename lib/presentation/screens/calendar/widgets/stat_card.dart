import 'package:flutter/material.dart';

import 'glass_card.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool isLarge;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.subtitle,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child:
          isLarge ? _buildLargeContent(context) : _buildSmallContent(context),
    );
  }

  Widget _buildLargeContent(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.38))),
            ]
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(shape: BoxShape.circle, color: iconBgColor),
          child: Icon(icon, color: iconColor, size: 28),
        ),
      ],
    );
  }

  Widget _buildSmallContent(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: iconBgColor,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: theme.textTheme.displaySmall,
            children: [
              TextSpan(text: value),
              if (subtitle != null)
                TextSpan(
                  text: subtitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.38)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
