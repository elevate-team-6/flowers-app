import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

abstract interface class LocationRepoContract {
  Future<LatLng?> getCurrentLocation();
  Future<Placemark?> getPlacemarkFromLocation(LatLng location);
}
