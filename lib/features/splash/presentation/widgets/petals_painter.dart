import 'dart:math' as math;

import 'package:flutter/material.dart';

class PetalData {
  final double size;
  final double speed;
  final double drift;
  final double rotation;
  final double startDelay;
  final Color color;
  final double horizontalOffset;

  PetalData({
    required this.size,
    required this.speed,
    required this.drift,
    required this.rotation,
    required this.startDelay,
    required this.color,
    required this.horizontalOffset,
  });
}

class PetalsPainter extends CustomPainter {
  final Animation<double> animation;
  final List<PetalData> petals;

  PetalsPainter({required this.animation, required this.petals})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (var petal in petals) {
      // Use speed to make some petals fall faster
      final double progress =
          (animation.value * petal.speed + petal.startDelay) % 1.0;

      // Calculate vertical position
      final double y = progress * (size.height + 60) - 30;

      // Calculate horizontal position with drift
      final double x =
          (petal.horizontalOffset * size.width) +
          (math.sin(progress * math.pi * 2) * petal.drift);

      final Paint paint = Paint()
        ..color = petal.color.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(petal.rotation + (progress * math.pi));

      // Draw petal (small oval)
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: petal.size,
          height: petal.size * 1.5,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant PetalsPainter oldDelegate) => true;
}
