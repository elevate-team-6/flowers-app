import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/track_order/data/models/tracked_order_model.dart';
import 'package:flowers_app/features/track_order/domain/entities/tracked_order_entity.dart';
import 'package:flowers_app/features/track_order/domain/repos/track_order_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackOrderRepoContract)
class TrackOrderRepoImpl implements TrackOrderRepoContract {
  final FirebaseFirestore _firestore;

  const TrackOrderRepoImpl(this._firestore);

  @override
  Stream<TrackedOrderEntity> watchOrder(String orderId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .snapshots()
        .map(TrackedOrderMapper.fromFirestore);
  }

  @override
  Future<RiderLocation?> getRiderLocation(String orderId) async {
    final doc = await _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .get();
    return TrackedOrderMapper.riderLocationFrom(doc.data());
  }
}
