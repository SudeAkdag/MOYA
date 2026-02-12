import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Merhaba, ',
            style: textTheme.headlineMedium,
            children: [
              TextSpan(
                text: 'Selin',
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Şu an nasıl hissediyorsun?',
          style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.6), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}