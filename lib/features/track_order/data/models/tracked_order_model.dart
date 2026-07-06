import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/track_order/domain/entities/tracked_order_entity.dart';

/// بيحوّل دوكيومنت orders/{orderId} من Firestore لـ [TrackedOrderEntity].
abstract class TrackedOrderMapper {
  static TrackedOrderEntity fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const {};

    return TrackedOrderEntity(
      orderId: doc.id,
      orderNumber: (data[AppConstants.orderNumberField] ?? '').toString(),
      status: TrackingStatus.fromString(
        data[AppConstants.statusField] as String?,
      ),
      riderId: data[AppConstants.riderIdField] as String?,
      riderName: data[AppConstants.riderNameField] as String?,
      riderPhone: data[AppConstants.riderPhoneField] as String?,
      shippingAddress: _shippingAddress(
        data[AppConstants.shippingAddressField],
      ),
      riderLocation: _riderLocation(data[AppConstants.riderLocationField]),
    );
  }

  static TrackedShippingAddress? _shippingAddress(dynamic raw) {
    if (raw is! Map) return null;
    return TrackedShippingAddress(
      street: (raw[AppConstants.streetField] ?? '').toString(),
      city: (raw[AppConstants.cityField] ?? '').toString(),
      phone: (raw[AppConstants.phoneField] ?? '').toString(),
      lat: (raw[AppConstants.latField] ?? '').toString(),
      long: (raw[AppConstants.longField] ?? '').toString(),
    );
  }

  /// بيقرأ موقع الرايدر من داتا الدوكيومنت مباشرة (للـ polling كل 5 ثواني).
  static RiderLocation? riderLocationFrom(Map<String, dynamic>? data) {
    if (data == null) return null;
    return _riderLocation(data[AppConstants.riderLocationField]);
  }

  /// lat/long متفق إنهم String في العقد. بنحاول نقرأ String أو number احتياطياً.
  static RiderLocation? _riderLocation(dynamic raw) {
    if (raw is! Map) return null;
    final lat = double.tryParse((raw[AppConstants.latField] ?? '').toString());
    final long = double.tryParse(
      (raw[AppConstants.longField] ?? '').toString(),
    );
    if (lat == null || long == null) return null;
    return RiderLocation(lat: lat, long: long);
  }
}
