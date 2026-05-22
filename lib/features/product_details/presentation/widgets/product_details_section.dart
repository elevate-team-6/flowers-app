import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({
    super.key,
    required this.price,
    required this.inStock,
    required this.descreption,
    required this.title,
  });
  final int price;
  final bool inStock;
  final String title;
  final String descreption;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('EGP $price', style: AppTextStyles.black20700),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.status.tr(),
                      style: AppTextStyles.black16500,
                    ),
                    TextSpan(
                      text: inStock
                          ? AppStrings.inStock.tr()
                          : AppStrings.outOfStock.tr(),
                      style: AppTextStyles.black14400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(AppStrings.allPricesIncludeTax.tr(), style: AppTextStyles.gray12400),
          const SizedBox(height: 6),

          Text(title, style: AppTextStyles.black16500),
          const SizedBox(height: 12),
          Text(AppStrings.description.tr(), style: AppTextStyles.black16500),
          const SizedBox(height: 10),
          Text(
            descreption,
            style: AppTextStyles.black14400,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(AppStrings.bouqetInclude.tr(), style: AppTextStyles.black16500),
          const SizedBox(height: 10),
          Text(AppStrings.roses.tr(), style: AppTextStyles.black14400),
        ],
      ),
    );
  }
}
