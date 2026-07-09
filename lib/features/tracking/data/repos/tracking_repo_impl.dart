import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/tracking/data/data_sources/tracking_remote_data_source_contract.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/repos/tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackingRepoContract)
class TrackingRepoImpl implements TrackingRepoContract {
  final TrackingRemoteDataSourceContract _dataSource;

  const TrackingRepoImpl(this._dataSource);

  @override
  Stream<BaseResponse<TrackingEntity>> getTracking(String orderId) {
    return _dataSource.getTracking(orderId).map((result) {
      return switch (result) {
        SuccessBaseResponse(:final data) =>
          SuccessBaseResponse<TrackingEntity>(data.toEntity()),
        ErrorBaseResponse(:final errorMessage) =>
          ErrorBaseResponse<TrackingEntity>(errorMessage),
      };
    });
  }

  @override
  Future<BaseResponse<void>> confirmDelivered(String orderId) async {
    return await _dataSource.confirmDelivered(orderId);
  }
}
