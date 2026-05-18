import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';

class CartSummary extends StatelessWidget {
  final CartEntity cart;

  const CartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.items.fold<int>(
      0,
      (sum, item) => sum + (item.product.priceAfterDiscount * item.quantity),
    );
    const deliveryFee = 10;
    final total = subtotal + deliveryFee;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SummaryRow(
            label: AppStrings.subTotal,
            value: '$subtotal${AppStrings.dollar}',
          ),
          SizedBox(height: 8.h),
          _SummaryRow(
            label: AppStrings.deliveryFee,
            value: '$deliveryFee${AppStrings.dollar}',
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.white70, thickness: 0.5),
          SizedBox(height: 12.h),
          _SummaryRow(
            label: AppStrings.total,
            value: '$total${AppStrings.dollar}',
            isBold: true,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                AppStrings.checkout,
                style: AppTextStyles.white16500.copyWith(fontSize: 18.sp),
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyles.black16400.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                )
              : AppTextStyles.black16400,
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyles.black16400.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                )
              : AppTextStyles.black16400,
        ),
      ],
    );
  }
}
