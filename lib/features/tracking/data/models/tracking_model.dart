import 'package:cloud_firestore/cloud_firestore.dart' as fs show GeoPoint, Timestamp;
import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_status.dart';

class TrackingModel extends Equatable {
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final TrackingStatus status;
  final GeoPoint? customerLocation;
  final GeoPoint? riderLocation;
  final DateTime? estimatedArrival;

  const TrackingModel({
    required this.riderId,
    required this.riderName,
    required this.riderPhone,
    required this.status,
    this.customerLocation,
    this.riderLocation,
    this.estimatedArrival,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      riderId: json[AppConstants.riderIdField] as String?,
      riderName: json[AppConstants.riderNameField] as String?,
      riderPhone: json[AppConstants.riderPhoneField] as String?,
      status: _parseStatus(json[AppConstants.statusField] as String?),
      customerLocation: _geoPoint(json[AppConstants.shippingAddressField]),
      riderLocation: _geoPoint(json[AppConstants.riderLocationField]),
      estimatedArrival: _estimatedArrival(json[AppConstants.createdAtField]),
    );
  }

  TrackingEntity toEntity() {
    return TrackingEntity(
      riderId: riderId,
      riderName: riderName,
      riderPhone: riderPhone,
      status: status,
      customerLocation: customerLocation,
      riderLocation: riderLocation,
      estimatedArrival: estimatedArrival,
    );
  }

  static TrackingStatus _parseStatus(String? status) {
    return switch (status) {
      'accepted' => TrackingStatus.accepted,
      'preparing' => TrackingStatus.preparing,
      'onWay' => TrackingStatus.outForDelivery,
      'delivered' => TrackingStatus.delivered,
      _ => TrackingStatus.pending,
    };
  }

  /// بنقرأ الموقع من أكتر من شكل عشان مصدر الرايدر (تطبيق الرايدر/الباك-إند) ممكن
  /// يكتبه مختلف عن عنوان العميل:
  /// 1) Firestore GeoPoint أصلي.
  /// 2) Map بمفاتيح lat/long (زي عنوان العميل — String أو number).
  /// 3) Map بمفاتيح latitude/longitude.
  /// أي قيمة ناقصة/غلط → null (الماب بتخفي الماركر).
  static GeoPoint? _geoPoint(dynamic raw) {
    if (raw is fs.GeoPoint) {
      return GeoPoint(lat: raw.latitude, long: raw.longitude);
    }
    if (raw is! Map) return null;
    final lat = double.tryParse(
      (raw[AppConstants.latField] ?? raw['latitude'] ?? '').toString(),
    );
    final long = double.tryParse(
      (raw[AppConstants.longField] ?? raw['longitude'] ?? '').toString(),
    );
    if (lat == null || long == null) return null;
    return GeoPoint(lat: lat, long: long);
  }

  /// وقت الوصول المتوقع = وقت إنشاء الأوردر + مدة التوصيل الثابتة.
  /// createdAt بيتكتب كـ serverTimestamp، فبيرجع Timestamp (أو null لحظة الكتابة
  /// قبل ما السيرفر يثبّته). بنتعامل كمان مع String/int احتياطياً.
  static DateTime? _estimatedArrival(dynamic rawCreatedAt) {
    final createdAt = _parseDate(rawCreatedAt);
    if (createdAt == null) return null;
    return createdAt.add(
      const Duration(minutes: AppConstants.estimatedDeliveryMinutes),
    );
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw is fs.Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

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
