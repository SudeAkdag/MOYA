import 'package:flutter/material.dart';

class BreathingTechnique {
  final String title;
  final String subtitle;
  final String duration;
  final String tag;
  final Color color;
  final String imageUrl;
  final List<BreathingPhase> phases;

  const BreathingTechnique({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.tag,
    required this.color,
    required this.imageUrl,
    required this.phases,
  });
}

class BreathingPhase {
  final String instruction;
  final int duration;

  const BreathingPhase({
    required this.instruction,
    required this.duration,
  });
}
