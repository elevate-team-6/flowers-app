import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_text_styles.dart';

class OnboardingPage extends StatelessWidget {
  final Widget animationWidget;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.animationWidget,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.start, // Changed to start to push content up
      children: [
        SizedBox(height: size.height * 0.1), // Added top spacing
        SizedBox(
          height: size.height * 0.48, // Slightly reduced to lift everything
          child: animationWidget,
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            title,
            style: AppTextStyles.black5028700Playfair,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            description,
            style: AppTextStyles.gray14400Poppins05,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
