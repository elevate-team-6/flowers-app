import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:latlong2/latlong.dart';

sealed class AddressEvent {
  const AddressEvent();
}

class GetAddressesEvent extends AddressEvent {
  const GetAddressesEvent();
}

class AddAddressEvent extends AddressEvent {
  final AddressEntity address;
  const AddAddressEvent(this.address);
}

class UpdateAddressEvent extends AddressEvent {
  final AddressEntity address;
  const UpdateAddressEvent(this.address);
}

class DeleteAddressEvent extends AddressEvent {
  final String addressId;
  const DeleteAddressEvent(this.addressId);
}

class GetGovernoratesEvent extends AddressEvent {
  const GetGovernoratesEvent();
}

class GetCitiesEvent extends AddressEvent {
  final String governorateId;
  const GetCitiesEvent(this.governorateId);
}

class MapLocationPickedEvent extends AddressEvent {
  final LatLng location;
  const MapLocationPickedEvent(this.location);
}

class GovernorateChangedEvent extends AddressEvent {
  final String? governorateId;
  const GovernorateChangedEvent(this.governorateId);
}

class CityChangedEvent extends AddressEvent {
  final String? cityId;
  const CityChangedEvent(this.cityId);
}

class InitEditAddressEvent extends AddressEvent {
  final AddressEntity address;
  const InitEditAddressEvent(this.address);
}
