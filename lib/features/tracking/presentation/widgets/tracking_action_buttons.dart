import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_cubit.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingActionButtons extends StatelessWidget {
  final String orderId;

  const TrackingActionButtons({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      child: BlocSelector<TrackingCubit, TrackingState, bool>(
        selector: (state) => state.isTrackingLastStep,
        builder: (context, isTrackingLastStep) {
          if (!isTrackingLastStep) {
            return ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.mapScreen);
              },
              child: Text(
                AppStrings.showMap.tr(),
                style: AppTextStyles.white18500,
              ),
            );
          }

          return Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.mapScreen);
                  },
                  child: Text(
                    AppStrings.showMap.tr(),
                    style: AppTextStyles.white18500,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 4,
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
                  child: Text(
                    AppStrings.orderDelivered.tr(),
                    style: AppTextStyles.white18500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
