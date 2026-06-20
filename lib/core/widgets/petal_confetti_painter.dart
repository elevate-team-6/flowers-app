import 'dart:math';

import 'package:flutter/material.dart';

class ConfettiPetal {
  final double startX;
  final double startY;
  final double size;
  final double drift;
  final double rotationSpeed;
  final double delay;
  final Color color;

  ConfettiPetal({
    required this.startX,
    required this.startY,
    required this.size,
    required this.drift,
    required this.rotationSpeed,
    required this.delay,
    required this.color,
  });
}

class PetalConfettiPainter extends CustomPainter {
  final Animation<double> animation;
  final List<ConfettiPetal> petals;
  final bool isError;

  PetalConfettiPainter({
    required this.animation,
    required this.petals,
    required this.isError,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final petal in petals) {
      final double progress =
          ((animation.value - petal.delay) / (1 - petal.delay)).clamp(0.0, 1.0);

      if (progress <= 0.0 || progress >= 1.0) continue;

      double x =
          petal.startX * size.width + sin(progress * pi * 2) * petal.drift;
      double y =
          petal.startY * size.height +
          progress * (size.height * 1.5); // Much longer fall
      double opacity = (1.0 - progress).clamp(0.0, 1.0);
      double rotation = progress * pi * 2 * petal.rotationSpeed;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      paint.color = petal.color.withValues(alpha: opacity * 0.95); // More vivid

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: petal.size,
          height: petal.size * 1.4,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant PetalConfettiPainter oldDelegate) => true;
}
