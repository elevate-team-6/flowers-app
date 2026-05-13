import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomProductsShimmer extends StatelessWidget {
  const CustomProductsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.62,
        ),
        itemCount: 6,
        itemBuilder: (_, _) => const _ShimmerCard(),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.black10,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
              ),
            ),
          ),

          // Info placeholder
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Title
                  Container(
                    width: double.infinity,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: AppColors.black10,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),

                  // Price row
                  Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.black10,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Container(
                        width: 30.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.black10,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),

                  // Button placeholder
                  Container(
                    width: double.infinity,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.black10,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
