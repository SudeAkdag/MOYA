import 'package:flutter/material.dart';

class MoodChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // This painter uses hardcoded colors for the chart itself.
    // Theming this chart would require more information on how the theme should affect it.
    // For now, we leave it as it is.
    final linePaint = Paint()
      ..color = const Color(0xFF38bdf8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final linePath = Path()
      ..moveTo(0, h * 0.75)
      ..cubicTo(w * 0.12, h * 0.75, w * 0.15, h * 0.25, w * 0.25, h * 0.375)
      ..cubicTo(w * 0.35, h * 0.5, w * 0.41, h * 0.1875, w * 0.5, h * 0.1875)
      ..cubicTo(
          w * 0.59, h * 0.1875, w * 0.65, h * 0.5625, w * 0.75, h * 0.5625)
      ..cubicTo(w * 0.85, h * 0.5625, w * 0.91, h * 0.125, w, h * 0.3125);

    canvas.drawPath(linePath, linePaint);

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF38bdf8).withAlpha(77),
          const Color(0xFF38bdf8).withAlpha(0)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final fillPath = Path.from(linePath)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
