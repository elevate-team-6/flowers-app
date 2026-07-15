import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_empty_state_view.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:flowers_app/features/orders/presentation/view_model/orders_cubit.dart';
import 'package:flowers_app/features/orders/presentation/view_model/orders_event.dart';
import 'package:flowers_app/features/orders/presentation/view_model/orders_state.dart';
import 'package:flowers_app/features/orders/presentation/widgets/order_card.dart';
import 'package:flowers_app/features/orders/presentation/widgets/orders_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_error_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().doEvent(const GetUserOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Text(AppStrings.myOrders.tr()),
          bottom: TabBar(
            tabs: [
              Tab(text: AppStrings.active.tr()),
              Tab(text: AppStrings.completed.tr()),
            ],
          ),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading) {
              return const OrdersShimmer();
            }

            if (state.status == OrdersStatus.failure) {
              return CustomErrorState(
                message:
                    state.errorMessage ?? AppStrings.somethingWentWrong.tr(),
                onRetry: () => context.read<OrdersCubit>().doEvent(
                  const GetUserOrdersEvent(),
                ),
              );
            }

            return TabBarView(
              children: [
                _buildOrdersList(state.activeOrders, isActive: true),
                _buildOrdersList(state.completedOrders, isActive: false),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderEntity> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return CustomEmptyStateView(
        message: isActive
            ? AppStrings.noActiveOrders.tr()
            : AppStrings.noCompletedOrders.tr(),
        subtitle: isActive
            ? AppStrings.noActiveOrdersSubtitle.tr()
            : AppStrings.noCompletedOrdersSubtitle.tr(),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onActionPressed: () {
            // TODO: handle Track / Reorder action
          },
        );
      },
    );
  }
}
