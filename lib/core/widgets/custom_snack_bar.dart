import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/petal_confetti_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class CustomSnackBar {
  static void showSuccessMessage(String msg) {
    _show(msg, true);
  }

  static void showErrorMessage(String msg) {
    _show(msg, false);
  }

  static void _show(String msg, bool isSuccess) {
    BotToast.showCustomNotification(
      duration: const Duration(milliseconds: 4500),
      toastBuilder: (VoidCallback cancelFunc) {
        return _PetalToast(
          msg: msg,
          isSuccess: isSuccess,
          cancelFunc: cancelFunc,
        );
      },
    );
  }
}

class _PetalToast extends StatefulWidget {
  final String msg;
  final bool isSuccess;
  final VoidCallback cancelFunc;

  const _PetalToast({
    required this.msg,
    required this.isSuccess,
    required this.cancelFunc,
  });

  @override
  State<_PetalToast> createState() => _PetalToastState();
}

class _PetalToastState extends State<_PetalToast>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _confettiController;
  late AnimationController _swayController;
  late AnimationController _shakeController;
  late AnimationController _dismissMorphController;
  late AnimationController _floatController; // New: for the flying effect
  late AnimationController _entranceController; // New: for the ball entry

  late List<ConfettiPetal> _petals;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initControllers();
    _generatePetals();
    _startAnimations();
  }

  void _initControllers() {
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _swayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _dismissMorphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _dismissMorphController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.cancelFunc();
      }
    });
  }

  void _generatePetals() {
    _petals = List.generate(28, (index) {
      final List<Color> palette = widget.isSuccess
          ? [
              AppColors.primary,
              AppColors.pink30,
              AppColors.pink40,
              AppColors.pink50,
            ]
          : [
              AppColors.pink20,
              AppColors.pink30,
              AppColors.error.withValues(alpha: 0.8),
            ];

      return ConfettiPetal(
        startX: 0.5, // Start from center (the ball)
        startY: 0.5,
        size: _random.nextDouble() * 10 + 8,
        drift: _random.nextDouble() * 120 - 60,
        rotationSpeed: _random.nextDouble() * 3 + 1,
        delay: _random.nextDouble() * 0.5,
        color: palette[_random.nextInt(palette.length)],
      );
    });
  }

  void _startAnimations() {
    _entranceController.forward().then((_) {
      if (mounted) _morphController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _iconController.forward();
        _confettiController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _textController.forward();
    });

    if (widget.isSuccess) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        if (mounted) _swayController.forward();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1600), () {
        if (mounted) _shakeController.forward();
      });
    }

    Future.delayed(const Duration(milliseconds: 4200), () {
      if (mounted) _dismissMorphController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _morphController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _confettiController.dispose();
    _swayController.dispose();
    _shakeController.dispose();
    _floatController.dispose();
    _dismissMorphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, sin(_floatController.value * 2 * pi) * 5),
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Confetti layer
                    Positioned.fill(
                      child: OverflowBox(
                        maxHeight: 400,
                        maxWidth: 600,
                        child: AnimatedBuilder(
                          animation: _confettiController,
                          builder: (context, _) => CustomPaint(
                            painter: PetalConfettiPainter(
                              animation: _confettiController,
                              petals: _petals,
                              isError: !widget.isSuccess,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Card layer
                    _buildShakeWrapper(child: _buildMorphCard()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShakeWrapper({required Widget child}) {
    if (widget.isSuccess) return child;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final double t = _shakeController.value;
        if (t == 0 || t == 1) return child!;

        final double shake = sin(t * pi * 4) * 8; // More noticeable shake
        return Transform.translate(offset: Offset(shake, 0), child: child);
      },
      child: child,
    );
  }

  Widget _buildMorphCard() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _entranceController,
        _morphController,
        _dismissMorphController,
      ]),
      builder: (context, child) {
        final bool isRTL = Directionality.of(context) == ui.TextDirection.rtl;

        final double entrance = Curves.elasticOut.transform(
          _entranceController.value,
        );
        final double morph = Curves.easeInOutCubic.transform(
          _morphController.value,
        );
        final double dismiss = _dismissMorphController.value;
        final double progress = (morph - dismiss).clamp(0.0, 1.0);

        final double screenWidth = MediaQuery.of(context).size.width;
        final double startX = (isRTL ? 1 : -1) * (screenWidth / 2 + 50);
        final double currentX = ui.lerpDouble(startX, 0, entrance)!;

        // Slimmer & Calmer sizing
        final double targetWidth =
            screenWidth - 80; // More margin for a floating feel
        final double cardWidth = ui.lerpDouble(40, targetWidth, progress)!;
        final double cardHeight = ui.lerpDouble(40, 56, progress)!;
        final double radius = ui.lerpDouble(20, 16, progress)!;

        final double contentOpacity = ((progress - 0.6) * 2.5).clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(currentX, -dismiss * 80),
          child: Opacity(
            opacity: (entrance * 2 - dismiss * 3).clamp(0.0, 1.0),
            child: Container(
              width: cardWidth,
              constraints: BoxConstraints(minHeight: cardHeight),
              decoration: BoxDecoration(
                color: Colors.white, // Pure white base for a clean look
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: widget.isSuccess
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.error.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: progress > 0.4 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    // Very soft pastel gradients instead of glass
                    gradient: LinearGradient(
                      colors: widget.isSuccess
                          ? [
                              Colors.white,
                              AppColors.pink10.withValues(alpha: 0.3),
                            ]
                          : [
                              Colors.white,
                              AppColors.error.withValues(alpha: 0.03),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: progress < 0.4
                      ? _buildTheBud()
                      : _buildTheBloom(contentOpacity),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTheBud() {
    return Center(
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isSuccess
              ? AppColors.success.withValues(alpha: 0.8)
              : AppColors.error.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildTheBloom(double opacity) {
    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const SizedBox(width: 4),
            // Soft Icon
            ScaleTransition(
              scale: CurvedAnimation(
                parent: _iconController,
                curve: Curves.elasticOut,
              ),
              child: _buildSwayWrapper(
                child: Text(
                  widget.isSuccess ? '🌸' : '🥀',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Added to grow with content
                children: [
                  Text(
                    widget.isSuccess
                        ? AppStrings.success.tr()
                        : AppStrings.oops.tr(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: widget.isSuccess
                          ? AppColors.black50
                          : AppColors.error.withValues(alpha: 0.8),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.msg,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.black50.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // Minimal Close Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.cancelFunc,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: AppColors.gray.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwayWrapper({required Widget child}) {
    if (!widget.isSuccess) return child;

    return RotationTransition(
      turns:
          TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.08), weight: 25),
            TweenSequenceItem(
              tween: Tween(begin: -0.08, end: 0.08),
              weight: 50,
            ),
            TweenSequenceItem(tween: Tween(begin: 0.08, end: 0.0), weight: 25),
          ]).animate(
            CurvedAnimation(parent: _swayController, curve: Curves.easeInOut),
          ),
      child: child,
    );
  }
}
