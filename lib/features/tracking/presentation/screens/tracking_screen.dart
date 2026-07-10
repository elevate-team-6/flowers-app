import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_error_state_view.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_cubit.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_state.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/tracking_shimmer.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/tracking_success_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

          return TrackingSuccessBody(orderId: orderId, tracking: tracking);
        },
      ),
    );
  }
}
