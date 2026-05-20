import 'package:flowers_app/core/widgets/custom_product_card.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProductsGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(ProductEntity) onAddToCart;
  final Function(ProductEntity)? onTap;
  const CustomProductsGrid({
    super.key,
    required this.products,
    required this.onAddToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 163 / 229,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return CustomProductCard(
          product: product,
          onAddToCart: () => onAddToCart(product),
          onTap: onTap != null ? () => onTap!(product) : null,
        );
      },
    );
  }
}
