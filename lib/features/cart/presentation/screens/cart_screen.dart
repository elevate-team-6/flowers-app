import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/widgets/custom_error_state_view.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_delivery_address_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flowers_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:flowers_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:flowers_app/features/cart/presentation/widgets/cart_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        titleSpacing: 10.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CartBloc, CartState>(
              buildWhen: (prev, curr) =>
                  prev.cart?.numOfCartItems != curr.cart?.numOfCartItems ||
                  prev.status != curr.status,
              builder: (context, state) {
                final count = state.cart?.numOfCartItems ?? 0;
                final hasError = state.status == CartStatus.failure;

                return Row(
                  children: [
                    Text(
                      AppStrings.cart.tr(),
                      style: AppTextStyles.black16400.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!hasError)
                      Text(
                        ' ($count ${AppStrings.items.tr()})',
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
            SizedBox(height: 10.h),
            HomeDeliveryAddressSection(),
          ],
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        buildWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.cart?.items.length != curr.cart?.items.length,
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const CartShimmer();
          }

          if (state.status == CartStatus.failure) {
            return CustomErrorStateView(
              message: state.errorMessage ?? AppStrings.somethingWentWrong.tr(),
              onRetry: () {
                context.read<CartBloc>().add(const GetCartEvent());
              },
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
                  Text(
                    AppStrings.cartEmpty.tr(),
                    style: AppTextStyles.black16400,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: items.length + 1,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return BlocSelector<CartBloc, CartState, int>(
                  selector: (state) {
                    final items = state.cart?.items ?? [];
                    return items.fold<int>(
                      0,
                      (sum, item) =>
                          sum +
                          (item.product.priceAfterDiscount * item.quantity),
                    );
                  },
                  builder: (context, _) {
                    final cart = context.read<CartBloc>().state.cart;
                    if (cart == null) return const SizedBox();
                    return CartSummary(cart: cart);
                  },
                );
              }

              final itemIndex = index;

              return BlocSelector<
                CartBloc,
                CartState,
                ({CartItemEntity? item, bool isLoading})
              >(
                selector: (state) {
                  final items = state.cart?.items ?? [];
                  final item = itemIndex < items.length
                      ? items[itemIndex]
                      : null;
                  return (
                    item: item,
                    isLoading: item != null
                        ? state.isItemLoading(item.id)
                        : false,
                  );
                },
                builder: (context, data) {
                  final currentItem = data.item;
                  if (currentItem == null) return const SizedBox();
                  return CartItemCard(
                    item: currentItem,
                    isLoading: data.isLoading,
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
          );
        },
      ),
    );
  }
}
