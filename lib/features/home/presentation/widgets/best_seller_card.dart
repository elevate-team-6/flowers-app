import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BestSellerCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final VoidCallback? onTap;

  const BestSellerCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 140.w,
                height: 150.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 140.w,
                  height: 150.h,
                  color: AppColors.white60,
                  child: Center(
                    child: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(strokeWidth: 2.w),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 140.w,
                  height: 150.h,
                  color: AppColors.white60,
                  child: Icon(
                    Icons.local_florist,
                    color: AppColors.primary,
                    size: 40.r,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              price,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
