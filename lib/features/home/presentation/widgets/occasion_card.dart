import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OccasionCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onTap;

  const OccasionCard({
    super.key,
    required this.imageUrl,
    required this.label,
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
                    Icons.celebration,
                    color: AppColors.primary,
                    size: 32.r,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
