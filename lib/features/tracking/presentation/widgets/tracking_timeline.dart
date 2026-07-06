import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_status.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/tracking_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingTimeline extends StatelessWidget {
  final TrackingStatus status;

  const TrackingTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      AppStrings.trackingReceived.tr(),
      AppStrings.trackingPreparing.tr(),
      AppStrings.trackingOutForDelivery.tr(),
      AppStrings.trackingDelivered.tr(),
    ];

    // TODO: replace static date with real timestamp per step from API
    const staticDate = '03 Sep 2024 - 2:10';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          return TrackingStep(
            title: steps[index],
            subtitle: staticDate,
            isCompleted: status.isStepCompleted(index),
            isLast: index == steps.length - 1,
          );
        }),
      ),
    );
  }
}
