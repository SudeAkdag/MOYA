import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/auth/register/register_screen.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // --- VEYA AYIRICI ---
        Row(
          children: [
            Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.2))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("VEYA", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.2))),
          ],
        ),
        const SizedBox(height: 25),
        
        // --- HESAP OLUŞTUR BUTONU ---
        const Text(
          "Hesabın yok mu?",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.primaryColor), // Moya yeşili çerçeve
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              "Hesap Oluştur",
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}