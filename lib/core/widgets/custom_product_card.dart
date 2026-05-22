import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;
  final VoidCallback? onTap;
  final bool isInCart;
  final bool isLoading;

  const CustomProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onRemove,
    this.onTap,
    this.isInCart = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.white70, width: 1.w),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: product.imgCover,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (_, _, _) =>
                        Image.asset(AppImages.imageDefault, fit: BoxFit.cover),
                  ),
                ),
              ),

              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: AppTextStyles.black12400,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                flex: 3,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${AppStrings.egp.tr()} ${product.priceAfterDiscount}',
                                    style: AppTextStyles.black13400.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${product.price}',
                                    style: AppTextStyles.black12400.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${product.discount}%',
                                  style: AppTextStyles.gray12400.copyWith(
                                    color: AppColors.success,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Price row

                    // Add to cart button
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : (isInCart ? onRemove : onAddToCart),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 36.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: isInCart
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                      icon: isLoading
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : isInCart
                          ? Image.asset(
                              AppIcons.delete,
                              width: 16.w,
                              height: 16.w,
                              color: AppColors.white,
                            )
                          : Icon(
                              Icons.shopping_cart_outlined,
                              size: 16.sp,
                              color: AppColors.white,
                            ),
                      label: Text(
                        isLoading
                            ? AppStrings.loading.tr()
                            : isInCart
                            ? AppStrings.remove.tr()
                            : AppStrings.addToCart.tr(),
                        style: AppTextStyles.white16500.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
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
}
