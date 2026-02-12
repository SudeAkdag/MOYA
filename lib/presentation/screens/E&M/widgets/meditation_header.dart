import 'dart:ui';
import 'package:flutter/material.dart';

class MeditationHeader extends StatelessWidget {
  const MeditationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 90,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: theme.scaffoldBackgroundColor.withOpacity(0.85),
            padding: EdgeInsets.only(left: 24, right: 24, top: topPadding, bottom: 10),
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hoş Geldin",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Zihnini Özgür Bırak",
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.1)),
                  ),
                  child: Icon(Icons.notifications, color: theme.colorScheme.onSurface, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
