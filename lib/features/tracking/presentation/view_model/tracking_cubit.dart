import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_status.dart';
import 'package:flowers_app/features/tracking/domain/use_cases/get_route_use_case.dart';
import 'package:flowers_app/features/tracking/domain/use_cases/get_tracking_use_case.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final GetTrackingUseCase _getTrackingUseCase;
  final GetRouteUseCase _getRouteUseCase;
  StreamSubscription<BaseResponse<TrackingEntity>>? _trackingSubscription;

  static const GeoPoint _storeLocation = GeoPoint(
    lat: AppConstants.storeLatitude,
    long: AppConstants.storeLongitude,
  );

  // بنطلب مسار المتجر→العميل مرة واحدة بس (حتى لو وصلت تحديثات كتير قبل ما يجهز).
  bool _storeRouteRequested = false;

  // مفتاح آخر موقع رايدر اتجابله مسار — نتفادى إعادة الجلب لنفس الموقع.
  String? _lastRiderKey;

  TrackingCubit(this._getTrackingUseCase, this._getRouteUseCase)
    : super(const TrackingState());

  void getTracking(String orderId) {
    _trackingSubscription?.cancel();
    _storeRouteRequested = false;
    _lastRiderKey = null;
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

  /// بيظبّط المسارين حسب آخر بيانات تتبّع: المتجر→العميل (مرة واحدة) والرايدر→العميل
  /// (كل ما موقع الرايدر يتغيّر وهو خارج للتوصيل).
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

    // مش خارج للتوصيل أو الرايدر لسه مبعتش موقعه → نمسح مساره لو كان موجود.
    if (tracking.status != TrackingStatus.outForDelivery || rider == null) {
      if (state.riderRoutePoints != null || _lastRiderKey != null) {
        _lastRiderKey = null;
        emit(state.copyWith(riderRoutePoints: null));
      }
      return;
    }

    final key = '${rider.lat},${rider.long}';
    if (key == _lastRiderKey) return; // نفس الموقع، مفيش داعي لإعادة الجلب.
    _lastRiderKey = key;
    _fetchRiderRoute(rider, customer);
  }

  Future<void> _fetchRiderRoute(GeoPoint rider, GeoPoint customer) async {
    final points = await _resolveRoute(from: rider, to: customer);
    if (isClosed) return;
    // لو الحالة/الموقع اتغيّروا أثناء الجلب، متجاهلش نتيجة قديمة.
    if (_lastRiderKey != '${rider.lat},${rider.long}') return;
    emit(state.copyWith(riderRoutePoints: points));
  }

  /// بيرجّع نقاط المسار، ولو الـ API فشل أو رجّع فاضي بيرجع للخط المستقيم (نقطتين).
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
