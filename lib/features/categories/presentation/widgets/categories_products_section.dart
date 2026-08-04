import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_empty_state_view.dart';
import 'package:flowers_app/core/widgets/custom_products_grid.dart';
import 'package:flowers_app/core/widgets/custom_products_shimmer.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_cubit.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_error_state.dart';
import '../view_model/categories_state.dart';

class CategoriesProductsSection extends StatelessWidget {
  final CategoriesStates state;

  const CategoriesProductsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.productsState.isLoading) {
      return const CustomProductsShimmer();
    }

    if (state.productsState.errorMessage != null) {
      return CustomErrorState(
        message: state.productsState.errorMessage!,
        onRetry: () {
          context.read<CategoriesCubit>().doEvent(
            const GetProductsRequestedEvent(),
          );
        },
      );
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

    return CustomEmptyStateView(
      message: AppStrings.noProductsFound.tr(),
      subtitle: AppStrings.noProductsFoundSubtitle.tr(),
      onRetry: () {
        context.read<CategoriesCubit>().doEvent(
          const GetProductsRequestedEvent(),
        );
      },
    );
  }
}
