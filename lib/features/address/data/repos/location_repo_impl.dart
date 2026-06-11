import 'package:flowers_app/features/address/data/data_sources/location_service.dart';
import 'package:flowers_app/features/address/domain/repositories/location_repo_contract.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@Injectable(as: LocationRepoContract)
class LocationRepoImpl implements LocationRepoContract {
  final LocationService _locationService;

  LocationRepoImpl(this._locationService);

  @override
  Future<LatLng?> getCurrentLocation() {
    return _locationService.getCurrentLocation();
  }

  @override
  Future<Placemark?> getPlacemarkFromLocation(LatLng location) {
    return _locationService.getPlacemarkFromLocation(location);
  }
}
