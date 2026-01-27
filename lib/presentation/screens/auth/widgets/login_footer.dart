import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/auth/register/register_screen.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: theme.dividerColor.withAlpha(25))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("VEYA", style: TextStyle(color: Colors.white30, fontSize: 12)),
            ),
            Expanded(child: Divider(color: theme.dividerColor.withAlpha(25))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hesabın yok mu? ", style: TextStyle(color: Colors.white70)),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              child: Text(
                "Hesap Oluştur",
                style: TextStyle(
                  color: theme.colorScheme.primary, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}