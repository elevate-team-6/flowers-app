import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/extensions/date_time_extensions.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/utils/app_theme.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onActionPressed;

  const OrderCard({
    super.key,
    required this.order,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    // المنتج الأول (للعرض في الكارت)
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final productTitle = firstItem?.product.title ?? '';
    final productImage = firstItem?.product.imgCover ?? '';

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.white90, width: 1.w),
      ),
      child: Row(
        children: [
          // صورة المنتج
          Expanded(
            flex: 3,
            child: Container(
              width: 130.w,
              height: 110.w,
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: productImage,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (_, _, _) => const Icon(
                    Icons.local_florist_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // تفاصيل الـ order
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productTitle,
                    style: AppTextStyles.black12400.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${AppStrings.egp.tr()} ${order.totalPrice}',
                    style: AppTextStyles.black14400.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    order.isActive
                        ? '${AppStrings.orderNumber.tr()} ${order.orderNumber}'
                        : '${AppStrings.deliveredOn.tr()} ${order.updatedAt.toShortDate()}',
                    style: AppTextStyles.gray12400.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.white90,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    height: 32.h,
                    child: ElevatedButton(
                      onPressed: onActionPressed,
                      style: AppTheme.secondaryButtonStyle,
                      child: Text(
                        order.isActive
                            ? AppStrings.trackOrder.tr()
                            : AppStrings.reorder.tr(),
                      ),
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
