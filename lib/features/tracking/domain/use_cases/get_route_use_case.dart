import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/repos/tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRouteUseCase {
  final TrackingRepoContract _repo;

  const GetRouteUseCase(this._repo);

  Future<BaseResponse<RouteEntity>> call({
    required GeoPoint from,
    required GeoPoint to,
  }) => _repo.getRoute(from: from, to: to);
}
