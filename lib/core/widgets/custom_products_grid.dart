import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_product_card.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProductsGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(ProductEntity)? onTap;

  const CustomProductsGrid({super.key, required this.products, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (prev, curr) =>
          (curr.cart?.numOfCartItems ?? 0) > (prev.cart?.numOfCartItems ?? 0),
      listener: (context, state) {
        SnackBarServices.showSuccessMessage(AppStrings.addedToCart);
      },
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.62,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return BlocSelector<
            CartBloc,
            CartState,
            ({bool isInCart, bool isLoading, String? itemId})
          >(
            selector: (state) {
              final items = state.cart?.items ?? [];
              final cartItemIndex = items.indexWhere(
                (item) => item.product.id == product.id,
              );
              final isInCart = cartItemIndex != -1;
              final cartItem = isInCart ? items[cartItemIndex] : null;

              final isLoading =
                  state.loadingItems.contains(product.id) ||
                  (cartItem != null &&
                      state.loadingItems.contains(cartItem.id));

              return (
                isInCart: isInCart,
                isLoading: isLoading,
                itemId: cartItem?.id,
              );
            },
            builder: (context, data) {
              return CustomProductCard(
                product: product,
                isInCart: data.isInCart,
                isLoading: data.isLoading,
                onAddToCart: () => context.read<CartBloc>().add(
                  AddToCartEvent(productId: product.id),
                ),
                onRemove: () {
                  if (data.itemId != null) {
                    context.read<CartBloc>().add(
                      RemoveItemEvent(
                        itemId: data.itemId!,
                        productId: product.id,
                      ),
                    );
                  }
                },
                onTap: onTap != null ? () => onTap!(product) : null,
              );
            },
          );
        },
      ),
    );
  }
}
