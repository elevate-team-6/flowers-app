import 'package:flutter/material.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_products_grid.dart';
import 'package:flowers_app/core/widgets/custom_products_shimmer.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import '../view_model/categories_state.dart';

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
        onAddToCart: (product) {
          SnackBarServices.showSuccessMessage(
            '${product.title} added to cart! (Functionality coming soon)',
          );
        },
      );
    }

    return Center(child: Text(AppStrings.noProductsFound));
  }
}
