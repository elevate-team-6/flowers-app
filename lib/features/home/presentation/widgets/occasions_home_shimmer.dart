import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OccasionsHomeShimmer extends StatelessWidget {
  const OccasionsHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header placeholder
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(width: 100.w, height: 18.h, color: Colors.white),
        ),

        SizedBox(height: 12.h),

        SizedBox(
          height: 210,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 5,
              separatorBuilder: (_, _) => SizedBox(width: 12.w),
              itemBuilder: (_, _) => const _OccasionShimmerCard(),
            ),
          ),
        ),
      ],
    );
  }
}

class _OccasionShimmerCard extends StatelessWidget {
  const _OccasionShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // image
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              ),
            ),
          ),

          // label
          Expanded(
            flex: 1,
            child: Center(
              child: Container(width: 70.w, height: 10.h, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
