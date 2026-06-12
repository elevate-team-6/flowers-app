import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';

enum AddressDetailsStatus { initial, loading, success, noAddresses, error }

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

  final AddressDetailsStatus status;

  final DeliveryLocationStatus locationStatus;

  const AddressDetailsState({
    this.defaultAddressState = const BaseState(),
    this.status = AddressDetailsStatus.initial,
    this.locationStatus = DeliveryLocationStatus.initial,
  });

  AddressDetailsState copyWith({
    BaseState<AddressEntity?>? defaultAddressState,
    AddressDetailsStatus? status,
    DeliveryLocationStatus? locationStatus,
  }) {
    return AddressDetailsState(
      defaultAddressState: defaultAddressState ?? this.defaultAddressState,
      status: status ?? this.status,
      locationStatus: locationStatus ?? this.locationStatus,
    );
  }

  @override
  List<Object?> get props => [defaultAddressState, status, locationStatus];
}
