import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoginButton({super.key, required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Giriş Yap",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}