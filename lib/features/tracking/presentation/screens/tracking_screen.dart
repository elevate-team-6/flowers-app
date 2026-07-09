import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_error_state_view.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_cubit.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_state.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/rider_info_card.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/tracking_shimmer.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/tracking_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingScreen extends StatelessWidget {
  final String orderId;

  const TrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(AppStrings.orderTracking.tr()),
      ),
      body: BlocBuilder<TrackingCubit, TrackingState>(
        builder: (context, state) {
          if (state.status == TrackingStatusUi.loading) {
            return const TrackingShimmer();
          }

          if (state.status == TrackingStatusUi.failure) {
            return CustomErrorStateView(
              message: state.errorMessage ?? AppStrings.somethingWentWrong.tr(),
              onRetry: () => context.read<TrackingCubit>().getTracking(orderId),
            );
          }

          final tracking = state.tracking;
          if (tracking == null) {
            return CustomErrorStateView(
              message: AppStrings.somethingWentWrong.tr(),
              onRetry: () => context.read<TrackingCubit>().getTracking(orderId),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ── Estimated Arrival ──────────────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.estimatedArrival.tr(),
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 4.h),
                      // TODO: replace with real estimated time from API
                      Text(
                        '03 Sep 2024, 11:00 AM',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade300),

                // ── Scrollable Content ─────────────────────────────
                Expanded(
                  child: ListView(
                    children: [
                      RiderInfoCard(
                        riderName: tracking.riderName,
                        riderPhone: tracking.riderPhone,
                      ),
                      Center(
                        child: Image.asset(
                          AppImages.car,
                          width:
                              220.w, // يمكنك التحكم في العرض المناسب لشاشتك هنا
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TrackingTimeline(status: tracking.status),
                    ],
                  ),
                ),

                // ── Show Map / Delivered Button ───────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  child: BlocSelector<TrackingCubit, TrackingState, bool>(
                    selector: (state) => state.isTrackingLastStep,
                    builder: (context, isTrackingLastStep) {
                      if (!isTrackingLastStep) {
                        return SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            // TODO: implement map navigation
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Text(
                              AppStrings.showMap.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52.h,
                              child: ElevatedButton(
                                // TODO: implement map navigation
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                                child: Text(
                                  AppStrings.showMap.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: SizedBox(
                              height: 52.h,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final confirmed = await context
                                      .read<TrackingCubit>()
                                      .confirmDelivered(orderId);
                                  if (confirmed && context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.mainLayout,
                                      (route) => false,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                                child: Text(
                                  AppStrings.trackingDelivered.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
