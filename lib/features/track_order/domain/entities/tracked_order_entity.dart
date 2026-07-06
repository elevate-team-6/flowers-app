import 'package:equatable/equatable.dart';

/// حالة الأوردر زي ما بيكتبها تطبيق الرايدر على Firestore.
/// القيم النصّية متفق عليها في العقد بالحرف.
enum TrackingStatus {
  accepted,
  preparing,
  onWay,
  delivered,
  canceled,
  unknown;

  static TrackingStatus fromString(String? value) {
    switch (value) {
      case 'accepted':
        return TrackingStatus.accepted;
      case 'preparing':
        return TrackingStatus.preparing;
      case 'onWay':
        return TrackingStatus.onWay;
      case 'delivered':
        return TrackingStatus.delivered;
      case 'canceled':
        return TrackingStatus.canceled;
      default:
        return TrackingStatus.unknown;
    }
  }

  /// ترتيب الخطوة في الـ timeline: 0=Received, 1=Preparing, 2=Out for delivery,
  /// 3=Delivered. أي حالة غير معروفة (أو لسه الرايدر مكتبش) تتعامل كأول خطوة.
  /// canceled بترجع -1 (حالة خاصة).
  int get stepIndex {
    switch (this) {
      case TrackingStatus.accepted:
      case TrackingStatus.unknown:
        return 0;
      case TrackingStatus.preparing:
        return 1;
      case TrackingStatus.onWay:
        return 2;
      case TrackingStatus.delivered:
        return 3;
      case TrackingStatus.canceled:
        return -1;
    }
  }

  bool get isCanceled => this == TrackingStatus.canceled;
  bool get isDelivered => this == TrackingStatus.delivered;
}

/// عنوان توصيل العميل زي ما اتكتب وقت تأكيد الأوردر (lat/long مخزّنة كـ String).
class TrackedShippingAddress extends Equatable {
  final String street;
  final String city;
  final String phone;
  final String lat;
  final String long;

  const TrackedShippingAddress({
    required this.street,
    required this.city,
    required this.phone,
    required this.lat,
    required this.long,
  });

  double? get latitude => double.tryParse(lat);
  double? get longitude => double.tryParse(long);

  @override
  List<Object?> get props => [street, city, phone, lat, long];
}

/// موقع الرايدر الحي — لسه تطبيق الرايدر مبيكتبهوش، فبيفضل null دلوقتي.
class RiderLocation extends Equatable {
  final double lat;
  final double long;

  const RiderLocation({required this.lat, required this.long});

  @override
  List<Object?> get props => [lat, long];
}

class TrackedOrderEntity extends Equatable {
  final String orderId;
  final String orderNumber;
  final TrackingStatus status;
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final TrackedShippingAddress? shippingAddress;
  final RiderLocation? riderLocation;

  const TrackedOrderEntity({
    required this.orderId,
    this.orderNumber = '',
    this.status = TrackingStatus.unknown,
    this.riderId,
    this.riderName,
    this.riderPhone,
    this.shippingAddress,
    this.riderLocation,
  });

  TrackedOrderEntity copyWith({RiderLocation? riderLocation}) {
    return TrackedOrderEntity(
      orderId: orderId,
      orderNumber: orderNumber,
      status: status,
      riderId: riderId,
      riderName: riderName,
      riderPhone: riderPhone,
      shippingAddress: shippingAddress,
      riderLocation: riderLocation ?? this.riderLocation,
    );
  }

  /// الرايدر اتعيّن للأوردر (عنده اسم على الأقل).
  bool get hasRider => (riderName != null && riderName!.trim().isNotEmpty);

  bool get hasRiderPhone =>
      (riderPhone != null && riderPhone!.trim().isNotEmpty);

  @override
  List<Object?> get props => [
    orderId,
    orderNumber,
    status,
    riderId,
    riderName,
    riderPhone,
    shippingAddress,
    riderLocation,
  ];
}
