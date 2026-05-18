import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shimmer/shimmer.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final bool isLoading;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.isLoading,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.white90, width: 1.w),
      ),
      child: Row(
        children: [
          // Image with pink background
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.lightPink,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: item.product.imgCover,
                fit: BoxFit.cover,
                placeholder: (_, _) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (_, _, _) => Icon(
                  Icons.local_florist_outlined,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.title,
                            style: AppTextStyles.black14400.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            item.product.description,
                            style: AppTextStyles.gray14400.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white90,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: onRemove,
                      child: Image.asset(
                        AppIcons.delete,
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppStrings.egp} ${item.product.priceAfterDiscount}',
                      style: AppTextStyles.black14400.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    isLoading
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: onDecrement,
                                child: Icon(
                                  Icons.remove,
                                  size: 24.sp,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '${item.quantity}',
                                style: AppTextStyles.black14400.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: onIncrement,
                                child: Icon(
                                  Icons.add,
                                  size: 24.sp,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
