import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:flowers_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:flowers_app/features/cart/presentation/widgets/cart_shimmer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 10.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CartBloc, CartState>(
              buildWhen: (prev, curr) =>
                  prev.cart?.numOfCartItems != curr.cart?.numOfCartItems,
              builder: (context, state) {
                final count = state.cart?.numOfCartItems ?? 0;
                return Row(
                  children: [
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.cart,
                      style: AppTextStyles.black16400.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' ($count ${AppStrings.items})',
                      style: AppTextStyles.black16400.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white90,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Image.asset(AppIcons.location, width: 24.w, height: 24.w),
                SizedBox(width: 4.w),
                Text(
                  'Deliver to ',
                  style: AppTextStyles.gray12400.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white90,
                  ),
                ),
                Text(
                  ' 2XVP+XC - Sheikh Zayed.....',
                  style: AppTextStyles.black16400.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Image.asset(AppIcons.arrowRight, width: 24.w, height: 24.w),
              ],
            ),
          ],
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        buildWhen: (prev, curr) =>
            prev.status != curr.status || prev.cart?.items != curr.cart?.items,
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const CartShimmer();
          }

          if (state.status == CartStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? AppStrings.somethingWentWrong,
                style: AppTextStyles.black16400,
              ),
            );
          }

          final items = state.cart?.items ?? [];

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80.sp,
                    color: AppColors.black30,
                  ),
                  SizedBox(height: 16.h),
                  Text(AppStrings.cartEmpty, style: AppTextStyles.black16400),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return BlocBuilder<CartBloc, CartState>(
                      buildWhen: (prev, curr) {
                        final prevItem = prev.cart?.items.firstWhere(
                          (e) => e.id == item.id,
                          orElse: () => item,
                        );
                        final currItem = curr.cart?.items.firstWhere(
                          (e) => e.id == item.id,
                          orElse: () => item,
                        );
                        return prevItem != currItem ||
                            prev.isItemLoading(item.id) !=
                                curr.isItemLoading(item.id);
                      },
                      builder: (context, state) {
                        final currentItem = state.cart?.items.firstWhere(
                          (e) => e.id == item.id,
                          orElse: () => item,
                        );
                        if (currentItem == null) return const SizedBox();
                        return CartItemCard(
                          item: currentItem,
                          isLoading: state.isItemLoading(currentItem.id),
                          onIncrement: () {
                            context.read<CartBloc>().add(
                              UpdateQuantityEvent(
                                itemId: currentItem.id,
                                productId: currentItem.product.id,
                                quantity: currentItem.quantity + 1,
                              ),
                            );
                          },
                          onDecrement: () {
                            context.read<CartBloc>().add(
                              UpdateQuantityEvent(
                                itemId: currentItem.id,
                                productId: currentItem.product.id,
                                quantity: currentItem.quantity - 1,
                              ),
                            );
                          },
                          onRemove: () {
                            context.read<CartBloc>().add(
                              RemoveItemEvent(
                                itemId: currentItem.id,
                                productId: currentItem.product.id,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<CartBloc, CartState>(
                buildWhen: (prev, curr) => prev.cart?.items != curr.cart?.items,
                builder: (context, state) {
                  if (state.cart == null || state.cart!.items.isEmpty) {
                    return const SizedBox();
                  }
                  return CartSummary(cart: state.cart!);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
