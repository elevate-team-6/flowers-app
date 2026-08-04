import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_status.dart';
import 'package:flowers_app/features/tracking/domain/use_cases/confirm_delivered_use_case.dart';
import 'package:flowers_app/features/tracking/domain/use_cases/get_route_use_case.dart';
import 'package:flowers_app/features/tracking/domain/use_cases/get_tracking_use_case.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final GetTrackingUseCase _getTrackingUseCase;
  final GetRouteUseCase _getRouteUseCase;
  final ConfirmDeliveredUseCase _confirmDeliveredUseCase;

  StreamSubscription<BaseResponse<TrackingEntity>>? _trackingSubscription;

  static const GeoPoint _storeLocation = GeoPoint(
    lat: AppConstants.storeLatitude,
    long: AppConstants.storeLongitude,
  );

  /// نطلب Route المتجر → العميل مرة واحدة فقط.
  bool _storeRouteRequested = false;

  /// آخر موقع Rider تم جلب Route له.
  String? _lastRiderKey;

  TrackingCubit(
    this._getTrackingUseCase,
    this._getRouteUseCase,
    this._confirmDeliveredUseCase,
  ) : super(const TrackingState());

  void getTracking(String orderId) {
    _trackingSubscription?.cancel();

    _storeRouteRequested = false;
    _lastRiderKey = null;

    emit(state.copyWith(status: TrackingStatusUi.loading, errorMessage: null));

    _trackingSubscription = _getTrackingUseCase(orderId).listen(
      (result) {
        switch (result) {
          case SuccessBaseResponse(:final data):
            final isTrackingLastStep = data.status == TrackingStatus.delivered;

            emit(
              state.copyWith(
                status: TrackingStatusUi.success,
                tracking: data,
                isTrackingLastStep: isTrackingLastStep,
                errorMessage: null,
              ),
            );

            _syncRoutes(data);

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

  Future<bool> confirmDelivered(String orderId) async {
    final response = await _confirmDeliveredUseCase(orderId);

    switch (response) {
      case SuccessBaseResponse<void>():
        _trackingSubscription?.cancel();

        emit(
          state.copyWith(
            status: TrackingStatusUi.success,
            isTrackingLastStep: true,
            deliveryConfirmed: true,
            errorMessage: null,
          ),
        );

        return true;

      case ErrorBaseResponse(:final errorMessage):
        emit(
          state.copyWith(
            status: TrackingStatusUi.failure,
            errorMessage: errorMessage,
          ),
        );

        return false;
    }
  }

  /// يزامن Route المتجر → العميل و Route الرايدر → العميل.
  void _syncRoutes(TrackingEntity tracking) {
    final customer = tracking.customerLocation;
    if (customer == null) return;

    if (!_storeRouteRequested) {
      _storeRouteRequested = true;
      _fetchStoreRoute(customer);
    }

    _syncRiderRoute(tracking, customer);
  }

  Future<void> _fetchStoreRoute(GeoPoint customer) async {
    final points = await _resolveRoute(from: _storeLocation, to: customer);

    if (isClosed) return;

    emit(state.copyWith(routePoints: points));
  }

  void _syncRiderRoute(TrackingEntity tracking, GeoPoint customer) {
    final rider = tracking.riderLocation;

    if (tracking.status != TrackingStatus.outForDelivery || rider == null) {
      if (state.riderRoutePoints != null || _lastRiderKey != null) {
        _lastRiderKey = null;

        emit(state.copyWith(riderRoutePoints: null));
      }

      return;
    }

    final key = '${rider.lat},${rider.long}';

    if (key == _lastRiderKey) return;

    _lastRiderKey = key;

    _fetchRiderRoute(rider, customer);
  }

  Future<void> _fetchRiderRoute(GeoPoint rider, GeoPoint customer) async {
    final points = await _resolveRoute(from: rider, to: customer);

    if (isClosed) return;

    if (_lastRiderKey != '${rider.lat},${rider.long}') return;

    emit(state.copyWith(riderRoutePoints: points));
  }

  /// يرجع نقاط المسار، ولو الـ API فشل يرجع خط مستقيم.
  Future<List<GeoPoint>> _resolveRoute({
    required GeoPoint from,
    required GeoPoint to,
  }) async {
    final result = await _getRouteUseCase(from: from, to: to);

    if (result is SuccessBaseResponse<RouteEntity> &&
        result.data.points.isNotEmpty) {
      return result.data.points;
    }

    return [from, to];
  }

  @override
  Future<void> close() {
    _trackingSubscription?.cancel();
    return super.close();
  }
}
