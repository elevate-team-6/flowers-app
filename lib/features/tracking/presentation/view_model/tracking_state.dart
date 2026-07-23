import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';

enum TrackingStatusUi { initial, loading, success, failure }

/// حارس داخلي يفرّق بين "مش عايز أغيّر القيمة" و"عايز أخليها null" في [copyWith].
const Object _unset = Object();

class TrackingState extends Equatable {
  final TrackingStatusUi status;
  final TrackingEntity? tracking;
  final String? errorMessage;

  /// مسار المتجر → العميل (على الشوارع). null = لسه بيتحمّل.
  final List<GeoPoint>? routePoints;

  /// مسار الرايدر (موقعه الحي) → العميل. null = مفيش (مش خارج للتوصيل).
  final List<GeoPoint>? riderRoutePoints;

  const TrackingState({
    this.status = TrackingStatusUi.initial,
    this.tracking,
    this.errorMessage,
    this.routePoints,
    this.riderRoutePoints,
  });

  TrackingState copyWith({
    TrackingStatusUi? status,
    TrackingEntity? tracking,
    Object? errorMessage = _unset,
    Object? routePoints = _unset,
    Object? riderRoutePoints = _unset,
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
    );
  }

  @override
  List<Object?> get props => [
    status,
    tracking,
    errorMessage,
    routePoints,
    riderRoutePoints,
  ];
}
