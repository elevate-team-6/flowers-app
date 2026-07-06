import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/use_cases/get_tracking_use_case.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final GetTrackingUseCase _getTrackingUseCase;
  StreamSubscription<BaseResponse<TrackingEntity>>? _trackingSubscription;

  TrackingCubit(this._getTrackingUseCase) : super(const TrackingState());

  void getTracking(String orderId) {
    _trackingSubscription?.cancel();
    emit(state.copyWith(status: TrackingStatusUi.loading, errorMessage: null));

    _trackingSubscription = _getTrackingUseCase(orderId).listen(
      (result) {
        switch (result) {
          case SuccessBaseResponse(:final data):
            emit(
              state.copyWith(
                status: TrackingStatusUi.success,
                tracking: data,
                errorMessage: null,
              ),
            );
          case ErrorBaseResponse(:final errorMessage):
            emit(
              state.copyWith(
                status: TrackingStatusUi.failure,
                errorMessage: errorMessage,
              ),
            );
        }
      },
      onError: (_) {
        emit(
          state.copyWith(
            status: TrackingStatusUi.failure,
            errorMessage: AppStrings.somethingWentWrong.tr(),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _trackingSubscription?.cancel();
    return super.close();
  }
}
