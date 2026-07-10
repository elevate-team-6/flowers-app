import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/estimated_arrival_section.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/rider_info_card.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/tracking_action_buttons.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/tracking_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingSuccessBody extends StatelessWidget {
  final String orderId;
  final TrackingEntity tracking;

  const TrackingSuccessBody({
    super.key,
    required this.orderId,
    required this.tracking,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EstimatedArrivalSection(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: ListView(
              children: [
                RiderInfoCard(
                  riderName: tracking.riderName,
                  riderPhone: tracking.riderPhone,
                ),
                SizedBox(height: 32.h),
                Center(
                  child: Image.asset(
                    AppImages.car,
                    width: 220.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 32.h),
                TrackingTimeline(status: tracking.status),
              ],
            ),
          ),
        ),
        TrackingActionButtons(orderId: orderId),
      ],
    );
  }
}
