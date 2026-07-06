import 'package:flowers_app/features/track_order/domain/entities/tracked_order_entity.dart';

abstract class TrackOrderRepoContract {
  /// ستريم لحظي لدوكيومنت الأوردر على Firestore (snapshots listener).
  Stream<TrackedOrderEntity> watchOrder(String orderId);

  /// قراءة موقع الرايدر الحالي (one-shot) — بيتنادى كل 5 ثواني أثناء التوصيل.
  Future<RiderLocation?> getRiderLocation(String orderId);
}
