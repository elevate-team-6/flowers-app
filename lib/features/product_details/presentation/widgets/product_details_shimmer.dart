import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 400.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 20.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(height: 24.h, width: 140.w),

                    SizedBox(height: 10.h),

                    _buildShimmerBox(height: 16.h, width: 180.w),

                    SizedBox(height: 18.h),

                    _buildShimmerBox(height: 20.h, width: 220.w),

                    SizedBox(height: 20.h),

                    _buildShimmerBox(height: 22.h, width: 120.w),

                    SizedBox(height: 10.h),

                    _buildShimmerBox(
                      height: 14.h,
                      width: double.infinity,
                    ),

                    SizedBox(height: 8.h),

                    _buildShimmerBox(
                      height: 14.h,
                      width: double.infinity,
                    ),

                    SizedBox(height: 8.h),

                    _buildShimmerBox(
                      height: 14.h,
                      width: 250.w,
                    ),

                    SizedBox(height: 20.h),

                    _buildShimmerBox(height: 22.h, width: 150.w),

                    SizedBox(height: 10.h),

                    _buildShimmerBox(height: 14.h, width: 180.w),

                    SizedBox(height: 40.h),

                    _buildShimmerBox(
                      height: 55.h,
                      width: double.infinity,
                      radius: 30.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox({
    required double height,
    required double width,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}