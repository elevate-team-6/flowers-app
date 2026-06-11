import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddressMatcher {
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
