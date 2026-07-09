import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';

abstract interface class TrackingRepoContract {
  Stream<BaseResponse<TrackingEntity>> getTracking(String orderId);
  Future<BaseResponse<void>> confirmDelivered(String orderId);
}
