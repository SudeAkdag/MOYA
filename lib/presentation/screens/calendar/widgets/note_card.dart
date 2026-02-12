import 'package:flutter/material.dart';

import 'glass_card.dart';

class NoteCard extends StatelessWidget {
  final String note;
  final VoidCallback onDelete;
  const NoteCard({super.key, required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notes_rounded,
              color: theme.colorScheme.onBackground.withOpacity(0.38),
              size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              note,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.redAccent, size: 22),
            onPressed: onDelete,
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          )
        ],
      ),
    );
  }
}
