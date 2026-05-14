import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CustomProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onAddToCart;
  final VoidCallback? onTap;

  const CustomProductCard({
    super.key,
    required this.onAddToCart,
    this.onTap,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white20,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.white70, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r), // 8px padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.pink10.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: CachedNetworkImage(
                      imageUrl: product.imgCover,
                      errorListener: (error) => debugPrint(
                        'Image error: $error — URL: ${product.imgCover}',
                      ),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (_, _, _) => Center(
                        child: Icon(
                          Icons.local_florist_outlined,
                          size: 36.sp,
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h), // 8px gap
              Text(
                product.title,
                style: AppTextStyles.black13400,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'EGP ${product.priceAfterDiscount}',
                    style: AppTextStyles.black14600,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${product.price}',
                    style: AppTextStyles.gray11400LineThrough,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${product.discount}%',
                    style: AppTextStyles.green11400,
                  ),
                ],
              ),
              SizedBox(height: 8.h), // 8px gap
              ElevatedButton.icon(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, 32.h),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                icon: SvgPicture.asset(
                  AppIcons.cart,
                  width: 16.w,
                  height: 16.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  AppStrings.addToCart,
                  style: AppTextStyles.white12600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
