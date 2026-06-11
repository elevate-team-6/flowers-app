import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_products_grid.dart';
import 'package:flowers_app/core/widgets/custom_products_shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../view_model/categories_state.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoriesProductsSection extends StatelessWidget {
  final CategoriesStates state;

  const CategoriesProductsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.productsState.isLoading) {
      return const CustomProductsShimmer();
    }

    final products = state.productsState.data;

    if (products != null && products.isNotEmpty) {
      return CustomProductsGrid(
        products: products,
        onTap: (product) {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetails,
            arguments: product.id,
          );
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_florist_outlined,
            size: 80.sp,
            color: AppColors.black30,
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.noProductsFound.tr(),
            style: AppTextStyles.black16400,
          ),
        ],
      ),
    );
  }
}
