import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';

enum TrackingStatusUi { initial, loading, success, failure }

/// Internal sentinel to distinguish between
/// "keep current value" and "set value to null".
const Object _unset = Object();

class TrackingState extends Equatable {
  final TrackingStatusUi status;
  final TrackingEntity? tracking;
  final String? errorMessage;

  /// Store → Customer route.
  final List<GeoPoint>? routePoints;

  /// Rider → Customer route.
  final List<GeoPoint>? riderRoutePoints;

  final bool isTrackingLastStep;
  final bool deliveryConfirmed;

  const TrackingState({
    this.status = TrackingStatusUi.initial,
    this.tracking,
    this.errorMessage,
    this.routePoints,
    this.riderRoutePoints,
    this.isTrackingLastStep = false,
    this.deliveryConfirmed = false,
  });

  TrackingState copyWith({
    TrackingStatusUi? status,
    TrackingEntity? tracking,
    Object? errorMessage = _unset,
    Object? routePoints = _unset,
    Object? riderRoutePoints = _unset,
    bool? isTrackingLastStep,
    bool? deliveryConfirmed,
  }) {
    return TrackingState(
      status: status ?? this.status,
      tracking: tracking ?? this.tracking,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      routePoints: identical(routePoints, _unset)
          ? this.routePoints
          : routePoints as List<GeoPoint>?,
      riderRoutePoints: identical(riderRoutePoints, _unset)
          ? this.riderRoutePoints
          : riderRoutePoints as List<GeoPoint>?,
      isTrackingLastStep: isTrackingLastStep ?? this.isTrackingLastStep,
      deliveryConfirmed: deliveryConfirmed ?? this.deliveryConfirmed,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tracking,
    errorMessage,
    routePoints,
    riderRoutePoints,
    isTrackingLastStep,
    deliveryConfirmed,
  ];
}
