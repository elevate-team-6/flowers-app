import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/track_order/domain/entities/tracked_order_entity.dart';
import 'package:flowers_app/features/track_order/presentation/view_model/track_order_cubit.dart';
import 'package:flowers_app/features/track_order/presentation/view_model/track_order_states.dart';
import 'package:flowers_app/features/track_order/presentation/widgets/rider_contact_card.dart';
import 'package:flowers_app/features/track_order/presentation/widgets/tracking_step_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  static const List<String> _stepTitles = [
    AppStrings.receivedYourOrder,
    AppStrings.preparingYourOrder,
    AppStrings.outForDelivery,
    AppStrings.deliveredStep,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.trackOrder.tr()),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: BlocBuilder<TrackOrderCubit, TrackOrderStates>(
        builder: (context, state) {
          switch (state.status) {
            case TrackOrderStatus.loading:
            case TrackOrderStatus.initial:
              return const Center(child: CircularProgressIndicator());
            case TrackOrderStatus.error:
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    state.errorMessage ?? '',
                    style: AppTextStyles.gray14400,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            case TrackOrderStatus.success:
              final order = state.order!;
              return _TrackingBody(orderId: orderId, order: order);
          }
        },
      ),
    );
  }
}

class _TrackingBody extends StatelessWidget {
  final String orderId;
  final TrackedOrderEntity order;

  const _TrackingBody({required this.orderId, required this.order});

  @override
  Widget build(BuildContext context) {
    final isCanceled = order.status.isCanceled;
    final currentStep = order.status.stepIndex;
    final isDelivered = order.status.isDelivered;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.estimatedArrival.tr(),
                  style: AppTextStyles.gray12400,
                ),
                SizedBox(height: 4.h),
                Text(_estimatedArrival(), style: AppTextStyles.black16600),
                SizedBox(height: 24.h),
                RiderContactCard(order: order),
                SizedBox(height: 24.h),
                _VehicleBanner(),
                SizedBox(height: 24.h),
                if (isCanceled)
                  _CanceledBanner()
                else
                  ...List.generate(OrderTrackingScreen._stepTitles.length, (i) {
                    return TrackingStepTile(
                      title: OrderTrackingScreen._stepTitles[i].tr(),
                      isReached: i <= currentStep,
                      isCurrent: i == currentStep,
                      isLast: i == OrderTrackingScreen._stepTitles.length - 1,
                    );
                  }),
              ],
            ),
          ),
        ),
        _BottomBar(
          orderId: orderId,
          isDelivered: isDelivered,
          isCanceled: isCanceled,
        ),
      ],
    );
  }

  String _estimatedArrival() {
    // مفيش ETA حقيقي في العقد؛ بنعرض تقدير تقريبي (النهارده + يومين).
    final estimate = DateTime.now().add(const Duration(days: 2));
    return DateFormat('dd MMM yyyy, hh:mm a').format(estimate);
  }
}

class _VehicleBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.local_shipping,
        size: 90.r,
        color: AppColors.primary,
      ),
    );
  }
}

class _CanceledBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.gray10,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel_outlined, color: AppColors.error),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              AppStrings.orderCanceled.tr(),
              style: AppTextStyles.black14600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String orderId;
  final bool isDelivered;
  final bool isCanceled;

  const _BottomBar({
    required this.orderId,
    required this.isDelivered,
    required this.isCanceled,
  });

  @override
  Widget build(BuildContext context) {
    if (isCanceled) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isDelivered
              ? null
              : () => Navigator.pushNamed(
                  context,
                  AppRoutes.orderMap,
                  arguments: orderId,
                ),
          child: Text(
            isDelivered
                ? AppStrings.orderDelivered.tr()
                : AppStrings.showMap.tr(),
          ),
        ),
      ),
    );
  }
}
