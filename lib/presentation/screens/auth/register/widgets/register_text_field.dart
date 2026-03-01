import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const RegisterTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text, required bool isPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor.withOpacity(0.8),
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            cursorColor: theme.primaryColor,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              // Hint kaldırıldı
              prefixIcon: Icon(icon, color: theme.primaryColor, size: 20),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}