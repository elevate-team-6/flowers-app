import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:latlong2/latlong.dart';

class AddressStates extends Equatable {
  final BaseState<List<AddressEntity>> addressesState;
  final BaseState<List<GovernorateEntity>> governoratesState;
  final BaseState<List<CityEntity>> citiesState;
  final BaseState<bool> actionState;

  // Selection data for the form
  final LatLng? selectedLocation;
  final String? selectedGovernorateId;
  final String? selectedCityId;
  final String? autoAddressDetails;

  const AddressStates({
    this.addressesState = const BaseState(),
    this.governoratesState = const BaseState(),
    this.citiesState = const BaseState(),
    this.actionState = const BaseState(),
    this.selectedLocation,
    this.selectedGovernorateId,
    this.selectedCityId,
    this.autoAddressDetails,
  });

  AddressStates copyWith({
    BaseState<List<AddressEntity>>? addressesState,
    BaseState<List<GovernorateEntity>>? governoratesState,
    BaseState<List<CityEntity>>? citiesState,
    BaseState<bool>? actionState,
    LatLng? selectedLocation,
    String? selectedGovernorateId,
    String? selectedCityId,
    String? autoAddressDetails,
    bool resetCity = false,
  }) {
    return AddressStates(
      addressesState: addressesState ?? this.addressesState,
      governoratesState: governoratesState ?? this.governoratesState,
      citiesState: citiesState ?? this.citiesState,
      actionState: actionState ?? this.actionState,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedGovernorateId:
          selectedGovernorateId ?? this.selectedGovernorateId,
      selectedCityId: resetCity
          ? null
          : (selectedCityId ?? this.selectedCityId),
      autoAddressDetails: autoAddressDetails ?? this.autoAddressDetails,
    );
  }

  @override
  List<Object?> get props => [
    addressesState,
    governoratesState,
    citiesState,
    actionState,
    selectedLocation,
    selectedGovernorateId,
    selectedCityId,
    autoAddressDetails,
  ];
}
