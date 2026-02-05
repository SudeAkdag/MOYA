import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1), // İkon arkası hafif ana renk
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20), // İkon rengi ana renk
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onSurface, // Temanın yazı rengi
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, color: theme.colorScheme.outline, size: 16),
    );
  }
}