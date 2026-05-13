import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_product_card.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/utils/products_shimmer.dart';
import 'package:flowers_app/features/home/best_seller/presentation/cubit/best_seller_cubit.dart';
import 'package:flowers_app/features/home/best_seller/presentation/cubit/best_seller_state.dart';
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
          SnackBarServices.showErrorMessage(
            state.bestSellerState.errorMessage!,
          );
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
              const Text(AppStrings.bestSeller),
              Text(
                AppStrings.subTitleBestSeller,
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
              return const ProductsShimmer();
            }
            if (state.bestSellerState.errorMessage != null) {
              return const SizedBox();
            }
            final products = state.bestSellerState.data ?? [];
            if (products.isEmpty) {
              return const Center(child: Text(AppStrings.noProductsFound));
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.72,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return AppProductCard(
                    imgCover: product.imgCover,
                    title: product.title,
                    price: product.price,
                    priceAfterDiscount: product.priceAfterDiscount,
                    discount: product.discount,
                    onAddToCart: () {},
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
