import 'dart:ui';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;
  final String initials; 

  const HomeAppBar({
    super.key, 
    required this.onMenuTap, 
    required this.onProfileTap,
    required this.initials, 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      expandedHeight: 100.0,
      backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.85),
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
            child: GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.colorScheme.secondary],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.cardTheme.color,
                  ),
                  child: Center(
                    child: Text(
                      initials, // Dinamik baş harfler
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12, 
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}