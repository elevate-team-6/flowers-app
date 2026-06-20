import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class PageFourAnimation extends StatefulWidget {
  final bool isActive;
  const PageFourAnimation({super.key, required this.isActive});

  @override
  State<PageFourAnimation> createState() => _PageFourAnimationState();
}

class _PageFourAnimationState extends State<PageFourAnimation>
    with TickerProviderStateMixin {
  late AnimationController _phoneController;
  late AnimationController _notifController;
  late AnimationController _shakeController;
  late AnimationController _heartController;

  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _phoneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _notifController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 6.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    _phoneController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _notifController.forward();
      }
    });

    _notifController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.forward();
      }
    });

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _heartController.forward();
      }
    });

    _heartController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted && widget.isActive) {
          _resetAndRestart();
        }
      }
    });

    if (widget.isActive) {
      _phoneController.forward();
    }
  }

  void _resetAndRestart() {
    _phoneController.reset();
    _notifController.reset();
    _shakeController.reset();
    _heartController.reset();
    _phoneController.forward();
  }

  @override
  void didUpdateWidget(PageFourAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _resetAndRestart();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _notifController.dispose();
    _shakeController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 350,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Phone and Notification
            AnimatedBuilder(
              animation: Listenable.merge([
                _phoneController,
                _notifController,
                _shakeController,
              ]),
              builder: (context, child) {
                final phoneScale = CurvedAnimation(
                  parent: _phoneController,
                  curve: Curves.easeOutBack,
                ).value;
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Transform.scale(
                    scale: phoneScale,
                    child: CustomPaint(
                      size: const Size(110, 190),
                      painter: PhonePainter(notifValue: _notifController.value),
                    ),
                  ),
                );
              },
            ),
            // Floating Heart
            AnimatedBuilder(
              animation: _heartController,
              builder: (context, child) {
                if (_heartController.value == 0) return const SizedBox.shrink();

                final val = _heartController.value;
                final opacity = (1.0 - val).clamp(0.0, 1.0);
                final scale = 0.5 + (val * 0.9);
                final slideY = val * -150.0;

                return Transform.translate(
                  offset: Offset(0, 50 + slideY),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: CustomPaint(
                        size: const Size(30, 30),
                        painter: HeartPainter(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PhonePainter extends CustomPainter {
  final double notifValue;

  PhonePainter({required this.notifValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Phase 1: Phone Body
    canvas.save();
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 110, height: 190),
      const Radius.circular(20),
    );
    final phonePaint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = AppColors.pink20
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(phoneRect, phonePaint);
    canvas.drawRRect(phoneRect, borderPaint);

    // Inner screen
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 102, height: 182),
      const Radius.circular(17),
    );
    canvas.drawRRect(
      screenRect,
      Paint()..color = AppColors.pink10.withOpacity(0.3),
    );

    // Home indicator
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - 15, center.dy + 85, 30, 4),
        const Radius.circular(2),
      ),
      Paint()..color = AppColors.pink20,
    );

    // Notch
    canvas.drawCircle(
      Offset(center.dx, center.dy - 85),
      3,
      Paint()..color = AppColors.pink20,
    );
    canvas.restore();

    // Phase 2: Notification Card
    if (notifValue > 0) {
      canvas.save();
      final dropValue = Curves.bounceOut.transform(notifValue);
      // Offset(0, -3.0) to Offset(0, -2.2) roughly mapping to screen position
      final yOffset = -40 + (dropValue * 30);
      canvas.translate(center.dx, center.dy + yOffset);

      final notifRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 90, height: 48),
        const Radius.circular(10),
      );

      // Shadow
      canvas.drawRRect(
        notifRect.shift(const Offset(0, 4)),
        Paint()
          ..color = AppColors.pink10.withOpacity(0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      canvas.drawRRect(notifRect, Paint()..color = Colors.white);
      canvas.drawRRect(
        notifRect,
        Paint()
          ..color = AppColors.pink20
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      // Notification content
      _drawNotifText(canvas);

      canvas.restore();
    }
  }

  void _drawNotifText(Canvas canvas) {
    // Icon
    const textStyle = TextStyle(fontSize: 14);
    const textSpan = TextSpan(text: '🌸', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(-38, -18));

    // Title
    final titlePainter = TextPainter(
      text: const TextSpan(
        text: 'Your flowers are',
        style: TextStyle(
          color: AppColors.black50,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(canvas, const Offset(-20, -16));

    // Subtitle
    final subPainter = TextPainter(
      text: const TextSpan(
        text: 'on the way! 🌸',
        style: TextStyle(color: AppColors.gray, fontSize: 7),
      ),
      textDirection: TextDirection.ltr,
    );
    subPainter.layout();
    subPainter.paint(canvas, const Offset(-20, -4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    final path = Path();

    final width = size.width;
    final height = size.height;

    path.moveTo(width / 2, height / 4);
    path.cubicTo(
      width * 5 / 6,
      height / 10,
      width,
      height / 2,
      width / 2,
      height * 4 / 5,
    );
    path.cubicTo(0, height / 2, width / 6, height / 10, width / 2, height / 4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
