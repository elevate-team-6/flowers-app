import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_snack_bar.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:flowers_app/features/product_details/presentation/widgets/product_details_section.dart';
import 'package:flowers_app/features/product_details/presentation/widgets/product_details_shimmer.dart';
import 'package:flowers_app/features/product_details/presentation/widgets/product_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsState>(
      listenWhen: (previous, current) {
        return previous.productDetailsState.errorMessage !=
            current.productDetailsState.errorMessage;
      },
      listener: (context, state) {
        if (state.productDetailsState.errorMessage != null) {
          CustomSnackBar.showErrorMessage(
            state.productDetailsState.errorMessage!,
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state.productDetailsState.isLoading) {
              return const ProductDetailsShimmer();
            }
            if (state.productDetailsState.errorMessage != null) {
              return const SizedBox();
            }
            final productDetails = state.productDetailsState.data;
            if (productDetails == null) {
              return Center(child: Text(AppStrings.noProductDetailsFound.tr()));
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    children: [
                      ProductImageSlider(
                        productImageSlider: productDetails.images,
                      ),
                      SizedBox(height: 6.h),
                      ProductDetailsSection(
                        price: productDetails.price,
                        inStock: productDetails.quantity > 0,
                        descreption: productDetails.description,
                        title: productDetails.title,
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child:
                            BlocSelector<
                              CartBloc,
                              CartState,
                              ({bool isInCart, bool isLoading, String? itemId})
                            >(
                              selector: (state) {
                                final items = state.cart?.items ?? [];
                                final index = items.indexWhere(
                                  (item) =>
                                      item.product.id == productDetails.id,
                                );
                                final isInCart = index != -1;
                                final cartItem = isInCart ? items[index] : null;

                                final isLoading =
                                    state.loadingItems.contains(
                                      productDetails.id,
                                    ) ||
                                    (cartItem != null &&
                                        state.loadingItems.contains(
                                          cartItem.id,
                                        ));

                                return (
                                  isInCart: isInCart,
                                  isLoading: isLoading,
                                  itemId: cartItem?.id,
                                );
                              },
                              builder: (context, data) {
                                return ElevatedButton(
                                  onPressed: data.isLoading
                                      ? null
                                      : () {
                                          if (data.isInCart) {
                                            if (data.itemId != null) {
                                              context.read<CartBloc>().add(
                                                RemoveItemEvent(
                                                  itemId: data.itemId!,
                                                  productId: productDetails.id,
                                                ),
                                              );
                                            }
                                          } else {
                                            context.read<CartBloc>().add(
                                              AddToCartEvent(
                                                product: productDetails
                                                    .toProductEntity(),
                                              ),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: data.isInCart
                                        ? AppColors.error
                                        : AppColors.primary,
                                  ),
                                  child: data.isLoading
                                      ? SizedBox(
                                          width: 20.w,
                                          height: 20.w,
                                          child:
                                              const CircularProgressIndicator(
                                                color: AppColors.white,
                                                strokeWidth: 2,
                                              ),
                                        )
                                      : Text(
                                          data.isInCart
                                              ? AppStrings.remove.tr()
                                              : AppStrings.addToCart.tr(),
                                        ),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
