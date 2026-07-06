import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class PageOneAnimation extends StatefulWidget {
  final bool isActive;
  const PageOneAnimation({super.key, required this.isActive});

  @override
  State<PageOneAnimation> createState() => _PageOneAnimationState();
}

class _PageOneAnimationState extends State<PageOneAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fades = List.generate(3, (index) {
      final start = (index * 150) / 1200;
      final end = (start + 700 / 1200).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    _slides = List.generate(3, (index) {
      final start = (index * 150) / 1200;
      final end = (start + 700 / 1200).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, -1.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant PageOneAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 220.h,
        width: 320.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Left Card
            Positioned(
              left: 0,
              top: 0,
              child: _buildCard("🌹", "Rose", _slides[0], _fades[0]),
            ),
            // Middle Card (Lower)
            Positioned(
              left: 100.w,
              top: 20.h,
              child: _buildCard("🌷", "Tulip", _slides[1], _fades[1]),
            ),
            // Right Card
            Positioned(
              left: 200.w,
              top: 0,
              child: _buildCard("🌸", "Blossom", _slides[2], _fades[2]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    String emoji,
    String name,
    Animation<Offset> slide,
    Animation<double> fade,
  ) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: Container(
          width: 120.w, // Reduced width to avoid overflow
          height: 180.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink20.withValues(alpha: 0.5),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: TextStyle(fontSize: 52.sp)),
              SizedBox(height: 8.h),
              Text(name, style: AppTextStyles.gray13400Poppins),
            ],
          ),
        ),
      ),
    );
  }
}
