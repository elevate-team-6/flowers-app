import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_error_state.dart';
import 'package:flowers_app/core/widgets/custom_products_grid.dart';
import 'package:flowers_app/core/widgets/custom_products_shimmer.dart';
import 'package:flowers_app/core/widgets/custom_snack_bar.dart';
import 'package:flowers_app/features/best_seller/presentation/cubit/best_seller_cubit.dart';
import 'package:flowers_app/features/best_seller/presentation/cubit/best_seller_event.dart';
import 'package:flowers_app/features/best_seller/presentation/cubit/best_seller_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BestSellerScreen extends StatelessWidget {
  const BestSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BestSellerCubit, BestSellerState>(
      listenWhen: (previous, current) =>
          previous.bestSellerState.errorMessage !=
          current.bestSellerState.errorMessage,
      listener: (context, state) {
        if (state.bestSellerState.errorMessage != null) {
          CustomSnackBar.showErrorMessage(state.bestSellerState.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(AppStrings.bestSeller.tr()),
              Text(
                AppStrings.subTitleBestSeller.tr(),
                style: AppTextStyles.black12400.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<BestSellerCubit, BestSellerState>(
          builder: (context, state) {
            if (state.bestSellerState.isLoading) {
              return const CustomProductsShimmer();
            }

            if (state.bestSellerState.errorMessage != null) {
              return CustomErrorState(
                message: state.bestSellerState.errorMessage!,
                onRetry: () {
                  context.read<BestSellerCubit>().doEvent(
                    GetBestSellerProductsEvent(),
                  );
                },
              );
            }

            final products = state.bestSellerState.data ?? [];
            if (products.isEmpty) {
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
          },
        ),
      ),
    );
  }
}
