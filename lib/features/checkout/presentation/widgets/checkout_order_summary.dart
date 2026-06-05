import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CheckoutOrderSummary extends StatelessWidget {
  final int subtotal;
  final int deliveryFee;
  final int total;

  const CheckoutOrderSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.subTotal.tr(),
              style: AppTextStyles.gray16400,
            ),
            Text(
              '$subtotal ${AppStrings.dollarSign.tr()}',
              style: AppTextStyles.gray16400,
            ),
          ],
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.deliveryFee.tr(),
              style: AppTextStyles.gray16400,
            ),
            Text(
              '$deliveryFee ${AppStrings.dollarSign.tr()}',
              style: AppTextStyles.gray16400,
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.total.tr(),
              style: AppTextStyles.black18500,
            ),
            Text(
              '$total ${AppStrings.dollarSign.tr()}',
              style: AppTextStyles.black18500,
            ),
          ],
        ),
      ],
    );
  }
}