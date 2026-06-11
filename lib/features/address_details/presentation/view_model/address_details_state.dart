import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';

enum AddressDetailsStatus {
  initial,
  loading,
  success,
  noAddresses,
  error,
}
enum DeliveryLocationStatus {
  initial,
  checking,
  enabled,
  locationDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class AddressDetailsState extends Equatable {
  final BaseState<AddressEntity?> defaultAddressState;
  final List<AddressEntity> addresses;

  final AddressDetailsStatus status;

  final DeliveryLocationStatus locationStatus;

  const AddressDetailsState({
    this.defaultAddressState = const BaseState(),
    this.addresses = const [],
    this.status = AddressDetailsStatus.initial,
    this.locationStatus = DeliveryLocationStatus.initial,
  });

  AddressDetailsState copyWith({
    BaseState<AddressEntity?>? defaultAddressState,
    List<AddressEntity>? addresses,
    AddressDetailsStatus? status,
    DeliveryLocationStatus? locationStatus,
  }) {
    return AddressDetailsState(
      defaultAddressState: defaultAddressState ?? this.defaultAddressState,
      addresses: addresses ?? this.addresses,
      status: status ?? this.status,
      locationStatus: locationStatus ?? this.locationStatus,
    );
  }

  @override
  List<Object?> get props => [
    defaultAddressState,
    addresses,
    status,
    locationStatus,
  ];
}