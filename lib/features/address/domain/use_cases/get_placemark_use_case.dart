import 'package:flowers_app/features/address/domain/repositories/location_repo_contract.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class GetPlacemarkUseCase {
  final LocationRepoContract _repository;

  GetPlacemarkUseCase(this._repository);

  Future<Placemark?> call(LatLng location) {
    return _repository.getPlacemarkFromLocation(location);
  }
}
