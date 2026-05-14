import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BestSellerHomeShimmer extends StatelessWidget {
  const BestSellerHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header placeholder
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(width: 120.w, height: 18.h, color: Colors.white),
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
              itemBuilder: (_, _) => const _BestSellerShimmerCard(),
            ),
          ),
        ),
      ],
    );
  }
}

class _BestSellerShimmerCard extends StatelessWidget {
  const _BestSellerShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.h,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Container(width: 60.w, height: 10.h, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
