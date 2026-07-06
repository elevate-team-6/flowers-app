import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class OnboardingDots extends StatelessWidget {
  final int currentIndex;
  final int totalDots;

  const OnboardingDots({
    super.key,
    required this.currentIndex,
    this.totalDots = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: currentIndex == index ? 24.w : 8.w,
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColors.primary : AppColors.pink20,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}
