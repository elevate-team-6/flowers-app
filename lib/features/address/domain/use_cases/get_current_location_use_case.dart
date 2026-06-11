import 'package:flowers_app/features/address/domain/repositories/location_repo_contract.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class GetCurrentLocationUseCase {
  final LocationRepoContract _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<LatLng?> call() {
    return _repository.getCurrentLocation();
  }
}
