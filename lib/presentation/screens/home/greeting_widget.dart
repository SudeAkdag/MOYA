import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  final String name; 

  const GreetingWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: name, 
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor, fontSize: 24),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Şu an nasıl hissediyorsun?',
          style: textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6), 
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}