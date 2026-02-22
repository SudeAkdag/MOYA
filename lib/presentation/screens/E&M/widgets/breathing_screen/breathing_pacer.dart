import 'dart:math' as math;
import 'package:flutter/material.dart';

class BreathingPacer extends StatelessWidget {
  final String pacerText;
  final String pacerSubText;
  final AnimationController controller;

  const BreathingPacer({
    super.key,
    required this.pacerText,
    required this.pacerSubText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withOpacity(0.1), width: 1),
                ),
              ),
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
                ),
              ),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 60,
                      spreadRadius: 20,
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_outlined, color: primaryColor.withOpacity(0.8), size: 40),
                  const SizedBox(height: 12),
                  Text(pacerText, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 4),
                  Text(pacerSubText, style: TextStyle(fontSize: 14, color: primaryColor.withOpacity(0.8))),
                ],
              ),
              SizedBox(
                width: 220,
                height: 220,
                child: Transform.rotate(
                  angle: -math.pi / 2,
                  child: CircularProgressIndicator(
                    value: controller.value,
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    backgroundColor: theme.colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
