import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/tracking/domain/repos/tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConfirmDeliveredUseCase {
  final TrackingRepoContract _repo;

  const ConfirmDeliveredUseCase(this._repo);

  Future<BaseResponse<void>> call(String orderId) =>
      _repo.confirmDelivered(orderId);
}
