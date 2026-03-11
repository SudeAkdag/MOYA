import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        String displayName = "Kullanıcı";

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          String fullName = (userData['name'] ?? "").trim();

          if (fullName.isNotEmpty) {
            List<String> parts = fullName.split(RegExp(r'\s+'));
            if (parts.length >= 3) {
              // Örn: "Ayşe Fatma Yılmaz" -> "Ayşe Fatma"
              displayName = "${parts[0]} ${parts[1]}";
            } else {
              // Örn: "Selin Öztürk" -> "Selin" veya sadece "Selin"
              displayName = parts[0];
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: 'Merhaba, ',
                style: textTheme.headlineMedium,
                children: [
                  TextSpan(
                    text: displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: theme.primaryColor,
                    ),
                  ),
                ],
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
      },
    );
  }
}