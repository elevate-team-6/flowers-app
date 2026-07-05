import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/petal_confetti_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class CustomSnackBar {
  static void showSuccessMessage(String msg) => _show(msg, true);
  static void showErrorMessage(String msg) => _show(msg, false);

  static void _show(String msg, bool isSuccess) {
    BotToast.showCustomNotification(
      duration: const Duration(milliseconds: 4500),
      align: Alignment.topCenter,
      toastBuilder: (cancelFunc) =>
          _PetalToast(msg: msg, isSuccess: isSuccess, cancelFunc: cancelFunc),
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
  late AnimationController _morphController, _iconController, _textController;
  late AnimationController _confettiController,
      _swayController,
      _shakeController;
  late AnimationController _dismissMorphController;

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
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
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
    _dismissMorphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _dismissMorphController.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.cancelFunc();
    });
  }

  void _generatePetals() {
    _petals = List.generate(28, (index) {
      final palette = widget.isSuccess
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
        startX: 0.5,
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
    _morphController.forward();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _iconController.forward();
        _confettiController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        if (widget.isSuccess) {
          _swayController.forward();
        } else {
          _shakeController.forward();
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 4200), () {
      if (mounted) _dismissMorphController.forward();
    });
  }

  @override
  void dispose() {
    for (var c in [
      _morphController,
      _iconController,
      _textController,
      _confettiController,
      _swayController,
      _shakeController,
      _dismissMorphController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: OverflowBox(
                  maxHeight: 400.h,
                  maxWidth: 600.w,
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
              _buildShakeWrapper(child: _buildMorphCard()),
            ],
          ),
        ],
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
        return Transform.translate(
          offset: Offset(sin(t * pi * 4) * 8.w, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget _buildMorphCard() {
    return AnimatedBuilder(
      animation: Listenable.merge([_morphController, _dismissMorphController]),
      builder: (context, child) {
        final bool isRTL = Directionality.of(context) == ui.TextDirection.rtl;
        final double entrance = CurvedAnimation(
          parent: _morphController,
          curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
        ).value;
        final double morph = CurvedAnimation(
          parent: _morphController,
          curve: const Interval(0.4, 1.0, curve: Curves.easeInOutCubic),
        ).value;
        final double dismiss = _dismissMorphController.value;
        final double progress = (morph - dismiss).clamp(0.0, 1.0);

        final double screenWidth = MediaQuery.of(context).size.width;
        final double startX = (isRTL ? 1 : -1) * (screenWidth / 2 + 50.w);
        final double currentX = ui.lerpDouble(startX, 0, entrance)!;

        final double targetWidth = screenWidth - 80.w;
        final double cardWidth = ui.lerpDouble(40.w, targetWidth, progress)!;
        final double cardHeight = ui.lerpDouble(
          40.h,
          64.h,
          progress,
        )!; // Increased min height
        final double radius = ui.lerpDouble(20.r, 16.r, progress)!;

        return Transform.translate(
          offset: Offset(currentX, -dismiss * 80.h),
          child: Opacity(
            opacity: (entrance * 2 - dismiss * 3).clamp(0.0, 1.0),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: cardWidth,
                constraints: BoxConstraints(minHeight: cardHeight),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color:
                        (widget.isSuccess ? AppColors.primary : AppColors.error)
                            .withValues(alpha: 0.2),
                    width: 1.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15.r,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: progress > 0.4 ? 10.h : 0,
                    ), // More vertical padding
                    decoration: BoxDecoration(
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
                    child: _buildCardContent(progress),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(double progress) {
    final double contentOpacity = ((progress - 0.6) * 2.5).clamp(0.0, 1.0);
    return Stack(
      alignment: Alignment.center,
      children: [
        if (progress < 0.4)
          Container(
            width: 10.w,
            height: 10.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isSuccess
                  ? AppColors.success.withValues(alpha: 0.8)
                  : AppColors.error.withValues(alpha: 0.5),
            ),
          ),
        if (progress >= 0.4)
          Opacity(
            opacity: contentOpacity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
              ), // Slightly more horizontal padding
              child: Row(
                children: [
                  SizedBox(width: 4.w),
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _iconController,
                      curve: Curves.elasticOut,
                    ),
                    child: _buildSwayWrapper(
                      child: Text(
                        widget.isSuccess ? '🌸' : '🥀',
                        style: TextStyle(fontSize: 28.sp),
                      ),
                    ), // Back to larger icon
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.isSuccess
                              ? AppStrings.success.tr()
                              : AppStrings.oops.tr(),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3.sp, // Back to larger font
                            color: widget.isSuccess
                                ? AppColors.black50
                                : AppColors.error.withValues(alpha: 0.8),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          widget.msg,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            height: 1.3,
                            color: AppColors.black50.withValues(alpha: 0.6),
                          ), // Back to larger font
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.cancelFunc,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16.r,
                          color: AppColors.gray.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
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
