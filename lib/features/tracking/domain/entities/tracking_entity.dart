import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_status.dart';

/// نقطة جغرافية بسيطة (lat/long) — من غير أي اعتماد على مكتبة الخرائط في الـ domain.
class GeoPoint extends Equatable {
  final double lat;
  final double long;

  const GeoPoint({required this.lat, required this.long});

  @override
  List<Object?> get props => [lat, long];
}

/// مسار على الشوارع الفعلية بين نقطتين — مجرّد لستة نقاط ([GeoPoint]) بترسم الـ polyline.
class RouteEntity extends Equatable {
  final List<GeoPoint> points;

  const RouteEntity(this.points);

  @override
  List<Object?> get props => [points];
}

class TrackingEntity extends Equatable {
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final TrackingStatus status;

  /// موقع توصيل العميل (من عنوان الشحن المخزّن على الأوردر) — بيتحدّد وقت الأوردر.
  final GeoPoint? customerLocation;

  /// موقع الرايدر الحي — بيتحدّث لحظياً من نفس دوكيومنت الأوردر على Firestore.
  final GeoPoint? riderLocation;

  /// وقت الوصول المتوقع (محسوب: createdAt + مدة التوصيل الثابتة). null لو لسه
  /// الـ createdAt مكتبش على السيرفر (pending write).
  final DateTime? estimatedArrival;

  const TrackingEntity({
    required this.riderId,
    required this.riderName,
    required this.riderPhone,
    required this.status,
    this.customerLocation,
    this.riderLocation,
    this.estimatedArrival,
  });

  @override
  List<Object?> get props => [
    riderId,
    riderName,
    riderPhone,
    status,
    customerLocation,
    riderLocation,
    estimatedArrival,
  ];
}
