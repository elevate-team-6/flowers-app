import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          separatorBuilder: (_, __) => SizedBox(width: 16.w),
          itemBuilder: (_, __) => const _CategoryShimmerItem(),
        ),
      ),
    );
  }
}

class _CategoryShimmerItem extends StatelessWidget {
  const _CategoryShimmerItem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container (rounded square like image)
          Container(
            width: 55.w,
            height: 55.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),

          SizedBox(height: 8.h),

          // Text placeholder
          Container(
            width: 40.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}
