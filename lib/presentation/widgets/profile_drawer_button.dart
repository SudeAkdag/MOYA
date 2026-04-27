import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDrawerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileDrawerButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: IconButton(
        icon: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final String userName = userData['name'] ?? "";
              final String? profileImageUrl = userData['profileImageUrl'];
              
              if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
                return CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(profileImageUrl),
                );
              } else if (userName.isNotEmpty) {
                return CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.primaryColor.withOpacity(0.2),
                  child: Text(
                    userName[0].toUpperCase(),
                    style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              }
            }
            
            return CircleAvatar(
              radius: 16,
              backgroundColor: theme.primaryColor.withOpacity(0.2),
              child: Icon(Icons.person, size: 20, color: theme.primaryColor),
            );
          }
        ),
        onPressed: onPressed,
        tooltip: 'Menüyü Aç',
      ),
    );
  }
}