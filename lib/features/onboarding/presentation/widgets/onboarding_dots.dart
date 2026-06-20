import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class OnboardingDots extends StatelessWidget {
  final int currentIndex;
  final int totalDots;

  const OnboardingDots({
    super.key,
    required this.currentIndex,
    this.totalDots = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColors.primary : AppColors.pink20,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
