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
    return GridView.builder(
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
        return BlocBuilder<CartBloc, CartState>(
          buildWhen: (prev, curr) =>
              prev.cart?.items != curr.cart?.items ||
              prev.loadingItems != curr.loadingItems,
          builder: (context, state) {
            final isInCart =
                state.cart?.items.any(
                  (item) => item.product.id == product.id,
                ) ??
                false;
            final isLoading = state.loadingItems.contains(product.id);
            return CustomProductCard(
              product: product,
              isInCart: isInCart,
              isLoading: isLoading,
              onAddToCart: () => context.read<CartBloc>().add(
                AddToCartEvent(productId: product.id),
              ),
              onTap: onTap != null ? () => onTap!(product) : null,
            );
          },
        );
      },
    );
  }
}
