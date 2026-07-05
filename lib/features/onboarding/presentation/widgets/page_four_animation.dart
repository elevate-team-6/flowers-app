import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        width: 300.w,
        height: 350.h,
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
                  offset: Offset(_shakeAnimation.value.w, 0),
                  child: Transform.scale(
                    scale: phoneScale,
                    child: CustomPaint(
                      size: Size(110.w, 190.h),
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
                final slideY = val * -150.0.h;

                return Transform.translate(
                  offset: Offset(0, 50.h + slideY),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: CustomPaint(
                        size: Size(30.r, 30.r),
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
      Rect.fromCenter(center: center, width: 110.w, height: 190.h),
      Radius.circular(20.r),
    );
    final phonePaint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = AppColors.pink20
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.w;

    canvas.drawRRect(phoneRect, phonePaint);
    canvas.drawRRect(phoneRect, borderPaint);

    // Inner screen
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 102.w, height: 182.h),
      Radius.circular(17.r),
    );
    canvas.drawRRect(
      screenRect,
      Paint()..color = AppColors.pink10.withValues(alpha: 0.3),
    );

    // Home indicator
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - 15.w, center.dy + 85.h, 30.w, 4.h),
        Radius.circular(2.r),
      ),
      Paint()..color = AppColors.pink20,
    );

    // Notch
    canvas.drawCircle(
      Offset(center.dx, center.dy - 85.h),
      3.r,
      Paint()..color = AppColors.pink20,
    );
    canvas.restore();

    // Phase 2: Notification Card
    if (notifValue > 0) {
      canvas.save();
      final dropValue = Curves.bounceOut.transform(notifValue);
      // Offset(0, -3.0) to Offset(0, -2.2) roughly mapping to screen position
      final yOffset = -40.h + (dropValue * 30.h);
      canvas.translate(center.dx, center.dy + yOffset);

      final notifRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 90.w, height: 48.h),
        Radius.circular(10.r),
      );

      // Shadow
      canvas.drawRRect(
        notifRect.shift(Offset(0, 4.h)),
        Paint()
          ..color = AppColors.pink10.withValues(alpha: 0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.r),
      );

      canvas.drawRRect(notifRect, Paint()..color = Colors.white);
      canvas.drawRRect(
        notifRect,
        Paint()
          ..color = AppColors.pink20
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.w,
      );

      // Notification content
      _drawNotifText(canvas);

      canvas.restore();
    }
  }

  void _drawNotifText(Canvas canvas) {
    // Icon
    final textStyle = TextStyle(fontSize: 14.sp);
    final textSpan = TextSpan(text: '🌸', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-38.w, -18.h));

    // Title
    final titlePainter = TextPainter(
      text: TextSpan(
        text: 'Your flowers are',
        style: TextStyle(
          color: AppColors.black50,
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(canvas, Offset(-20.w, -16.h));

    // Subtitle
    final subPainter = TextPainter(
      text: TextSpan(
        text: 'on the way! 🌸',
        style: TextStyle(color: AppColors.gray, fontSize: 7.sp),
      ),
      textDirection: TextDirection.ltr,
    );
    subPainter.layout();
    subPainter.paint(canvas, Offset(-20.w, -4.h));
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
