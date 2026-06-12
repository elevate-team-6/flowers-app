import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class FindNearestAddressUseCase {
  const FindNearestAddressUseCase();

  AddressEntity? call({
    required Position currentPosition,
    required List<AddressEntity> addresses,
  }) {
    if (addresses.isEmpty) return null;

    AddressEntity nearestAddress = addresses.first;

    double nearestDistance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      double.tryParse(nearestAddress.latitude) ?? 0,
      double.tryParse(nearestAddress.longitude) ?? 0,
    );

    for (final address in addresses.skip(1)) {
      final lat = double.tryParse(address.latitude);
      final lng = double.tryParse(address.longitude);

      if (lat == null || lng == null) continue;

      final distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        lat,
        lng,
      );

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestAddress = address;
      }
    }

    return nearestAddress;
  }
}