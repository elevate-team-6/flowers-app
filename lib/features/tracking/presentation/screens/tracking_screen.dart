import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/helpers/date_time_extension.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_error_state_view.dart';
import 'package:flowers_app/features/tracking/presentation/screens/tracking_map_screen.dart';
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
                      Text(
                        tracking.estimatedArrival?.formatEstimatedArrival(
                              context.locale.languageCode,
                            ) ??
                            '—',
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

                // ── Show Map Button ────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      // نفتح الماب ونشارك نفس الـ TrackingCubit (نفس الستريم اللحظي).
                      onPressed: () {
                        final cubit = context.read<TrackingCubit>();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: cubit,
                              child: const TrackingMapScreen(),
                            ),
                          ),
                        );
                      },
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
              ],
            ),
          );
        },
      ),
    );
  }
}
