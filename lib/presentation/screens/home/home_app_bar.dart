import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key, 
    required this.onMenuTap, 
    required this.onProfileTap,
  });

  // İsim ve Soyismin baş harflerini alan geliştirilmiş fonksiyon
  String _getInitials(String name) {
    if (name.trim().isEmpty) return "??";
    
    // İsmi boşluklara göre parçalara ayır
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    
    if (parts.length > 1) {
      // Adın ilk harfi + Soyadın ilk harfi
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    
    // Sadece tek isim varsa ilk iki harfini veya tek harfini al
    return parts.first.length > 1 
        ? parts.first.substring(0, 2).toUpperCase() 
        : parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      expandedHeight: 100.0,
      backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.85), // withAlpha yerine güncel kullanım
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(bottom: 16),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.spa_outlined, color: theme.primaryColor, size: 20),
                const SizedBox(width: 4),
                Text(
                  'MOYA',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: Center(
        child: IconButton(
          icon: Icon(Icons.menu, size: 28, color: theme.colorScheme.onSurface),
          onPressed: onMenuTap,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
              builder: (context, snapshot) {
                String initials = "..";

                if (snapshot.hasData && snapshot.data!.exists) {
                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  final String fullName = userData['name'] ?? "Kullanıcı";
                  initials = _getInitials(fullName);
                }

                return GestureDetector(
                  onTap: onProfileTap,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [theme.primaryColor, theme.colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.cardTheme.color ?? theme.colorScheme.surface,
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13, 
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}