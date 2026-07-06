import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/tracking/data/models/tracking_model.dart';

abstract interface class TrackingRemoteDataSourceContract {
  Stream<BaseResponse<TrackingModel>> getTracking(String orderId);
}
