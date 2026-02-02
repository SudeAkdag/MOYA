import 'package:flutter/material.dart';

/// Clean Code: Uygulama genelinde listelerin boş olduğu durumlarda 
/// tutarlı bir görünüm sağlamak için kullanılan merkezi widget.
class EmptyStateView extends StatelessWidget {
  final String message;
  final IconData? icon;

  const EmptyStateView({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 64,
              color: Colors.grey.withAlpha(100),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}