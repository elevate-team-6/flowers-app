import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomCategoriesShimmer extends StatelessWidget {
  const CustomCategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: Shimmer.fromColors(
        baseColor: AppColors.white70,
        highlightColor: AppColors.white20,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: 6,
          separatorBuilder: (_, _) =>
              SizedBox(width: 24.w), // نفس الـ labelPadding
          itemBuilder: (_, _) => const _CategoryShimmerItem(),
        ),
      ),
    );
  }
}

class _CategoryShimmerItem extends StatelessWidget {
  const _CategoryShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // محاكي للنص (Text Placeholder)
        Container(
          width: 50.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 6.h),
        // محاكي للخط اللي تحت التابة (Indicator Placeholder)
        Container(
          width: 50.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ],
    );
  }
}
