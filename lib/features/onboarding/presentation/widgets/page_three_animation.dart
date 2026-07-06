import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class PageThreeAnimation extends StatefulWidget {
  final bool isActive;
  const PageThreeAnimation({super.key, required this.isActive});

  @override
  State<PageThreeAnimation> createState() => _PageThreeAnimationState();
}

class _PageThreeAnimationState extends State<PageThreeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _petalsController;
  late AnimationController _bouquetController;
  late AnimationController _ribbonController;
  late AnimationController _sparkleController;

  late List<Animation<Offset>> _petalSlides;
  late List<Animation<double>> _petalOpacities;

  @override
  void initState() {
    super.initState();
    _petalsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _bouquetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _ribbonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _setupPetalAnimations();

    _petalsController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bouquetController.forward();
      }
    });

    _bouquetController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _ribbonController.forward();
      }
    });

    _ribbonController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _sparkleController.forward();
      }
    });

    _sparkleController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 2000));
        if (mounted && widget.isActive) {
          _resetAndRestart();
        }
      }
    });

    if (widget.isActive) {
      _petalsController.forward();
    }
  }

  void _setupPetalAnimations() {
    final startOffsets = [
      const Offset(-1.8, -1.2),
      const Offset(1.8, -1.2),
      const Offset(-2.0, 0.2),
      const Offset(2.0, 0.2),
      const Offset(-1.0, 1.8),
      const Offset(1.0, 1.8),
    ];

    _petalSlides = [];
    _petalOpacities = [];

    for (int i = 0; i < 6; i++) {
      final startDelay = (i * 100) / 1000;
      final end = (startDelay + 0.4).clamp(0.0, 1.0);

      _petalSlides.add(
        Tween<Offset>(begin: startOffsets[i], end: Offset.zero).animate(
          CurvedAnimation(
            parent: _petalsController,
            curve: Interval(startDelay, end, curve: Curves.easeOutCubic),
          ),
        ),
      );

      _petalOpacities.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _petalsController,
            curve: Interval(
              startDelay,
              startDelay + 0.15,
              curve: Curves.linear,
            ),
          ),
        ),
      );
    }
  }

  void _resetAndRestart() {
    if (!mounted) return;
    _petalsController.reset();
    _bouquetController.reset();
    _ribbonController.reset();
    _sparkleController.reset();
    _petalsController.forward();
  }

  @override
  void didUpdateWidget(PageThreeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _resetAndRestart();
    }
  }

  @override
  void dispose() {
    _petalsController.dispose();
    _bouquetController.dispose();
    _ribbonController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320.w,
        height: 350.h,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _petalsController,
            _bouquetController,
            _ribbonController,
            _sparkleController,
          ]),
          builder: (context, child) {
            return CustomPaint(
              painter: MasterpieceBouquetPainter(
                petalSlides: _petalSlides,
                petalOpacities: _petalOpacities,
                bouquetValue: _bouquetController.value,
                ribbonValue: _ribbonController.value,
                sparkleValue: _sparkleController.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MasterpieceBouquetPainter extends CustomPainter {
  final List<Animation<Offset>> petalSlides;
  final List<Animation<double>> petalOpacities;
  final double bouquetValue;
  final double ribbonValue;
  final double sparkleValue;

  MasterpieceBouquetPainter({
    required this.petalSlides,
    required this.petalOpacities,
    required this.bouquetValue,
    required this.ribbonValue,
    required this.sparkleValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 20.h);

    // Phase 1: Converging Petals
    if (bouquetValue < 0.2) {
      _paintConvergingPetals(canvas, center);
    }

    // Phase 2: Masterpiece Bouquet Blooming
    if (bouquetValue > 0) {
      _paintBouquet(canvas, center);
    }

    // Phase 3: Satin Ribbon & Bow
    if (ribbonValue > 0) {
      _paintSatinRibbon(canvas, center);
    }

    // Final Touch: Sparkles & Dust
    if (sparkleValue > 0) {
      _paintPremiumSparkles(canvas, center);
    }
  }

  void _paintConvergingPetals(Canvas canvas, Offset center) {
    final colors = [
      AppColors.pink20,
      AppColors.pink30,
      AppColors.pink40,
      AppColors.pink20,
      AppColors.pink30,
      AppColors.pink10,
    ];
    for (int i = 0; i < 6; i++) {
      if (petalOpacities[i].value > 0) {
        canvas.save();
        final offset = petalSlides[i].value;
        final pos = center + Offset(offset.dx * 130.w, offset.dy * 130.h);
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(offset.dx * math.pi + (bouquetValue * 2));

        final paint = Paint()
          ..color = colors[i].withValues(alpha: petalOpacities[i].value);
        canvas.drawOval(Rect.fromLTWH(-5.w, -8.h, 10.w, 16.h), paint);
        canvas.restore();
      }
    }
  }

  void _paintBouquet(Canvas canvas, Offset center) {
    // 1. Wrapping Paper (Tissue + Outer Wrap)
    _paintPremiumWrapping(canvas, center);

    // 2. Stems
    _paintOrganicStems(canvas, center);

    // 3. Foliage (Leaves & Fillers)
    _paintLushFoliage(canvas, center);

    // 4. Blooming Flowers
    _paintBloomingFlowers(canvas, center);
  }

  void _paintPremiumWrapping(Canvas canvas, Offset center) {
    final tValue = (bouquetValue * 1.2).clamp(0.0, 1.0);
    final scale = Curves.easeOutBack.transform(tValue);

    canvas.save();
    canvas.translate(center.dx, center.dy + 80.h);
    canvas.scale(scale);
    canvas.translate(-center.dx, -(center.dy + 80.h));

    // Tissue Layer (White/Pink)
    final tissuePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final tissuePath = Path();
    tissuePath.moveTo(center.dx - 45.w, center.dy + 20.h);
    tissuePath.quadraticBezierTo(
      center.dx,
      center.dy + 10.h,
      center.dx + 45.w,
      center.dy + 20.h,
    );
    tissuePath.lineTo(center.dx + 25.w, center.dy + 110.h);
    tissuePath.lineTo(center.dx - 25.w, center.dy + 110.h);
    tissuePath.close();
    canvas.drawPath(tissuePath, tissuePaint);

    // Outer Luxury Wrap (Matte Pink)
    final wrapPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.pink20, AppColors.pink30.withValues(alpha: 0.9)],
      ).createShader(Rect.fromLTWH(center.dx - 40.w, center.dy + 35.h, 80.w, 80.h));

    final wrapPath = Path();
    wrapPath.moveTo(center.dx - 40.w, center.dy + 35.h);
    wrapPath.lineTo(center.dx + 40.w, center.dy + 35.h);
    wrapPath.quadraticBezierTo(
      center.dx + 35.w,
      center.dy + 80.h,
      center.dx + 20.w,
      center.dy + 115.h,
    );
    wrapPath.lineTo(center.dx - 20.w, center.dy + 115.h);
    wrapPath.quadraticBezierTo(
      center.dx - 35.w,
      center.dy + 80.h,
      center.dx - 40.w,
      center.dy + 35.h,
    );
    canvas.drawPath(wrapPath, wrapPaint);

    // Fold Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.w;
    canvas.drawLine(
      Offset(center.dx, center.dy + 35.h),
      Offset(center.dx, center.dy + 115.h),
      shadowPaint,
    );

    canvas.restore();
  }

  void _paintOrganicStems(Canvas canvas, Offset center) {
    final tValue = (bouquetValue * 1.5).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 2.0.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final base = center + Offset(0, 110.h);

    final stemPoints = [
      Offset(center.dx, center.dy - 30.h),
      Offset(center.dx - 40.w, center.dy - 10.h),
      Offset(center.dx + 40.w, center.dy - 10.h),
      Offset(center.dx - 25.w, center.dy - 50.h),
      Offset(center.dx + 25.w, center.dy - 50.h),
    ];

    for (var i = 0; i < stemPoints.length; i++) {
      final progress = (tValue * 1.2 - (i * 0.1)).clamp(0.0, 1.0);
      if (progress > 0) {
        final path = Path();
        path.moveTo(base.dx, base.dy);
        final endPoint = Offset(
          base.dx + (stemPoints[i].dx - base.dx) * progress,
          base.dy + (stemPoints[i].dy - base.dy) * progress,
        );
        path.quadraticBezierTo(
          center.dx + (stemPoints[i].dx - center.dx) * 0.5,
          center.dy + 40.h,
          endPoint.dx,
          endPoint.dy,
        );
        canvas.drawPath(path, paint);
      }
    }
  }

  void _paintLushFoliage(Canvas canvas, Offset center) {
    final paint = Paint()..color = const Color(0xFF4CAF50);
    final leafProgress = (bouquetValue * 2 - 0.5).clamp(0.0, 1.0);
    if (leafProgress <= 0) return;

    final positions = [
      Offset(center.dx - 30.w, center.dy + 20.h),
      Offset(center.dx + 30.w, center.dy + 20.h),
      Offset(center.dx - 50.w, center.dy + 40.h),
      Offset(center.dx + 50.w, center.dy + 40.h),
      Offset(center.dx, center.dy + 50.h),
    ];

    for (int i = 0; i < positions.length; i++) {
      final scale = Curves.easeOutBack.transform(
        (leafProgress * 1.2 - (i * 0.1)).clamp(0.0, 1.0),
      );
      if (scale > 0) {
        canvas.save();
        canvas.translate(positions[i].dx, positions[i].dy);
        canvas.scale(scale);
        canvas.rotate(i % 2 == 0 ? -math.pi / 5 : math.pi / 5);

        final leafPath = Path();
        leafPath.moveTo(0, 0);
        leafPath.quadraticBezierTo(10.w, -10.h, 20.w, 0);
        leafPath.quadraticBezierTo(10.w, 10.h, 0, 0);
        canvas.drawPath(leafPath, paint);

        // Leaf vein
        final veinPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.1)
          ..strokeWidth = 1.w;
        canvas.drawLine(const Offset(0, 0), Offset(18.w, 0), veinPaint);

        canvas.restore();
      }
    }

    // Baby's Breath (Filler)
    final fillerPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    for (int i = 0; i < 8; i++) {
      final fillerScale = Curves.elasticOut.transform(
        (leafProgress * 1.5 - (i * 0.1)).clamp(0.0, 1.0),
      );
      if (fillerScale > 0) {
        final angle = i * (math.pi * 2 / 8);
        final r = 60.0.r;
        canvas.drawCircle(
          Offset(
            center.dx + math.cos(angle) * r,
            center.dy + math.sin(angle) * r - 20.h,
          ),
          2.r * fillerScale,
          fillerPaint,
        );
      }
    }
  }

  void _paintBloomingFlowers(Canvas canvas, Offset center) {
    // 1. Central Grand Rose (The Star)
    _drawBloomedRose(
      canvas,
      center + Offset(0, -35.h),
      AppColors.primary,
      28.r,
      bouquetValue,
    );

    // 2. Elegant Peonies
    _drawPeony(
      canvas,
      center + Offset(-45.w, -15.h),
      AppColors.pink40,
      20.r,
      (bouquetValue - 0.2) * 1.2,
    );
    _drawPeony(
      canvas,
      center + Offset(45.w, -15.h),
      AppColors.pink40,
      20.r,
      (bouquetValue - 0.3) * 1.2,
    );

    // 3. Delicate Lillies
    _drawLily(
      canvas,
      center + Offset(-30.w, -65.h),
      AppColors.pink20,
      15.r,
      (bouquetValue - 0.4) * 1.5,
    );
    _drawLily(
      canvas,
      center + Offset(30.w, -65.h),
      AppColors.pink20,
      15.r,
      (bouquetValue - 0.5) * 1.5,
    );
  }

  void _drawBloomedRose(
    Canvas canvas,
    Offset pos,
    Color color,
    double radius,
    double progress,
  ) {
    final scale = Curves.elasticOut.transform(progress.clamp(0.0, 1.0));
    if (scale <= 0) return;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(scale);

    final paint = Paint()..color = color;

    // Outer Petals
    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.rotate(i * 45 * math.pi / 180);
      canvas.drawOval(
        Rect.fromLTWH(-radius / 2.2, -radius, radius, radius * 1.1),
        paint,
      );
      canvas.restore();
    }

    // Inner Layer
    final innerPaint = Paint()..color = color.withValues(alpha: 0.9);
    for (int i = 0; i < 5; i++) {
      canvas.save();
      canvas.rotate(i * 72 * math.pi / 180 + 0.3);
      canvas.drawOval(
        Rect.fromLTWH(-radius / 3, -radius * 0.7, radius * 0.6, radius * 0.8),
        innerPaint,
      );
      canvas.restore();
    }

    // Center yellow disc (Like the side flowers)
    canvas.drawCircle(
      Offset.zero,
      radius * 0.25,
      Paint()..color = const Color(0xFFFFD54F),
    );

    canvas.restore();
  }

  void _drawPeony(
    Canvas canvas,
    Offset pos,
    Color color,
    double radius,
    double progress,
  ) {
    final scale = Curves.easeOutBack.transform(progress.clamp(0.0, 1.0));
    if (scale <= 0) return;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(scale);

    final paint = Paint()..color = color;
    for (int i = 0; i < 10; i++) {
      canvas.save();
      canvas.rotate(i * 36 * math.pi / 180);
      canvas.drawCircle(Offset(0, -radius * 0.5), radius * 0.6, paint);
      canvas.restore();
    }

    // Center yellow
    canvas.drawCircle(
      Offset.zero,
      radius * 0.3,
      Paint()..color = const Color(0xFFFFD54F),
    );
    canvas.restore();
  }

  void _drawLily(
    Canvas canvas,
    Offset pos,
    Color color,
    double radius,
    double progress,
  ) {
    final scale = Curves.easeOutQuart.transform(progress.clamp(0.0, 1.0));
    if (scale <= 0) return;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(scale);

    final paint = Paint()..color = color;
    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.rotate(i * 120 * math.pi / 180);
      final p = Path();
      p.moveTo(0, 0);
      p.quadraticBezierTo(radius, -radius, 0, -radius * 1.5);
      p.quadraticBezierTo(-radius, -radius, 0, 0);
      canvas.drawPath(p, paint);
      canvas.restore();
    }
    canvas.drawCircle(Offset.zero, 4, Paint()..color = AppColors.primary);
    canvas.restore();
  }

  void _paintSatinRibbon(Canvas canvas, Offset center) {
    final t = Curves.bounceOut.transform(ribbonValue);
    final pos = center + Offset(0, 85.h);

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(t);

    final ribbonPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primary, Color(0xFFE91E63)],
      ).createShader(Rect.fromLTWH(-30.w, -10.h, 60.w, 20.h));

    // Bow Loops (Large & Fluid)
    final bowPath = Path();
    bowPath.moveTo(0, 0);
    // Left loop
    bowPath.cubicTo(-40.w, -30.h, -40.w, 30.h, 0, 0);
    // Right loop
    bowPath.cubicTo(40.w, -30.h, 40.w, 30.h, 0, 0);
    canvas.drawPath(bowPath, ribbonPaint);

    // Ribbons Tails
    final tailPath = Path();
    tailPath.moveTo(-5.w, 5.h);
    tailPath.lineTo(-20.w, 35.h);
    tailPath.moveTo(5.w, 5.h);
    tailPath.lineTo(20.w, 35.h);
    canvas.drawPath(
      tailPath,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.w
        ..strokeCap = StrokeCap.round,
    );

    // Center Pearl
    canvas.drawCircle(Offset.zero, 8.r, ribbonPaint);
    canvas.drawCircle(
      Offset.zero,
      8.r,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.w,
    );

    canvas.restore();
  }

  void _paintPremiumSparkles(Canvas canvas, Offset center) {
    final random = math.Random(1337);
    for (int i = 0; i < 7; i++) {
      final delay = i * 0.1;
      if (sparkleValue > delay) {
        final val = ((sparkleValue - delay) * 2).clamp(0.0, 1.0);
        final opacity = (1.0 - val);
        final scale = Curves.easeOut.transform(val);

        canvas.save();
        canvas.translate(
          center.dx + (random.nextDouble() - 0.5) * 220.w,
          center.dy + (random.nextDouble() - 0.6) * 240.h,
        );
        canvas.scale(scale);

        final paint = Paint()
          ..color = (i % 2 == 0 ? AppColors.primary : Colors.white).withValues(
            alpha: opacity,
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.r);

        _drawSpark(canvas, (10 + random.nextDouble() * 8).r, paint);
        canvas.restore();
      }
    }
  }

  void _drawSpark(Canvas canvas, double size, Paint paint) {
    Path path = Path();
    for (int i = 0; i < 4; i++) {
      path.moveTo(0, -size);
      path.quadraticBezierTo(0, 0, size, 0);
      path.quadraticBezierTo(0, 0, 0, size);
      path.quadraticBezierTo(0, 0, -size, 0);
      path.quadraticBezierTo(0, 0, 0, -size);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
