import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@lazySingleton
class AddressService {
  /// Translates coordinates into a readable address string and a Placemark object.
  Future<Placemark?> getPlacemarkFromLocation(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (_) {
      return null;
    }
  }

  /// Formats a Placemark into a single street address string.
  String formatPlacemark(Placemark place) {
    return "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}"
        .replaceAll(RegExp(r'^,\s*|,\s*,|,\s*$'), '')
        .trim();
  }

  /// Finds a governorate ID by matching its name (En or Ar) with the administrative area.
  String? matchGovernorate(List<GovernorateEntity> governorates, String? name) {
    if (name == null) return null;
    try {
      return governorates
          .firstWhere(
            (gov) =>
                name.toLowerCase().contains(gov.nameEn.toLowerCase()) ||
                gov.nameAr.contains(name),
          )
          .id;
    } catch (_) {
      return null;
    }
  }

  /// Finds a city ID by matching its name with various Placemark fields.
  String? matchCity(List<CityEntity> cities, Placemark place) {
    try {
      return cities.firstWhere((city) {
        final cityName = city.nameEn.toLowerCase();
        return (place.subAdministrativeArea?.toLowerCase().contains(cityName) ??
                false) ||
            (place.locality?.toLowerCase().contains(cityName) ?? false) ||
            (place.subLocality?.toLowerCase().contains(cityName) ?? false);
      }).id;
    } catch (_) {
      return null;
    }
  }

  /// Simplified matching for address entity (used in InitEditAddress)
  String? matchCityByName(List<CityEntity> cities, String name) {
    try {
      return cities
          .firstWhere(
            (c) =>
                c.nameEn.toLowerCase() == name.toLowerCase() ||
                c.nameAr == name,
          )
          .id;
    } catch (_) {
      return null;
    }
  }
}
