import 'package:flowers_app/features/address/domain/entities/address_entity.dart';

sealed class AddressDetailsEvent {}

class InitializeAddressDetailsEvent extends AddressDetailsEvent {}

class RefreshAddressDetailsEvent extends AddressDetailsEvent {}

class ValidateLocationEvent extends AddressDetailsEvent {}

class SelectAddressEvent extends AddressDetailsEvent {
  final AddressEntity address;

  SelectAddressEvent(this.address);
}
