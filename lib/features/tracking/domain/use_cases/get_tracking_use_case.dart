import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/repos/tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTrackingUseCase {
  final TrackingRepoContract _repo;

  const GetTrackingUseCase(this._repo);

  Stream<BaseResponse<TrackingEntity>> call(String orderId) =>
      _repo.getTracking(orderId);
}
