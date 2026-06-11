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
  final BaseState<LatLng> currentLocationState;

  // Split action state to avoid ambiguity
  final BaseState<bool> addAddressState;
  final BaseState<bool> updateAddressState;
  final BaseState<bool> deleteAddressState;
  final String? deletingAddressId;

  // Selection data for the form
  final LatLng? selectedLocation;
  final String? selectedGovernorateId;
  final String? selectedCityId;
  final String? autoAddressDetails;

  const AddressStates({
    this.addressesState = const BaseState(),
    this.governoratesState = const BaseState(),
    this.citiesState = const BaseState(),
    this.currentLocationState = const BaseState(),
    this.addAddressState = const BaseState(),
    this.updateAddressState = const BaseState(),
    this.deleteAddressState = const BaseState(),
    this.deletingAddressId,
    this.selectedLocation,
    this.selectedGovernorateId,
    this.selectedCityId,
    this.autoAddressDetails,
  });

  AddressStates copyWith({
    BaseState<List<AddressEntity>>? addressesState,
    BaseState<List<GovernorateEntity>>? governoratesState,
    BaseState<List<CityEntity>>? citiesState,
    BaseState<LatLng>? currentLocationState,
    BaseState<bool>? addAddressState,
    BaseState<bool>? updateAddressState,
    BaseState<bool>? deleteAddressState,
    String? deletingAddressId,
    LatLng? selectedLocation,
    String? selectedGovernorateId,
    String? selectedCityId,
    String? autoAddressDetails,
    bool resetCity = false,
    bool resetDeletingId = false,
    bool resetLocation = false,
    bool resetGovernorate = false,
    bool resetAutoDetails = false,
  }) {
    return AddressStates(
      addressesState: addressesState ?? this.addressesState,
      governoratesState: governoratesState ?? this.governoratesState,
      citiesState: citiesState ?? this.citiesState,
      currentLocationState: currentLocationState ?? this.currentLocationState,
      addAddressState: addAddressState ?? this.addAddressState,
      updateAddressState: updateAddressState ?? this.updateAddressState,
      deleteAddressState: deleteAddressState ?? this.deleteAddressState,
      deletingAddressId: resetDeletingId
          ? null
          : (deletingAddressId ?? this.deletingAddressId),
      selectedLocation: resetLocation
          ? null
          : (selectedLocation ?? this.selectedLocation),
      selectedGovernorateId: resetGovernorate
          ? null
          : (selectedGovernorateId ?? this.selectedGovernorateId),
      selectedCityId: resetCity
          ? null
          : (selectedCityId ?? this.selectedCityId),
      autoAddressDetails: resetAutoDetails
          ? null
          : (autoAddressDetails ?? this.autoAddressDetails),
    );
  }

  @override
  List<Object?> get props => [
    addressesState,
    governoratesState,
    citiesState,
    currentLocationState,
    addAddressState,
    updateAddressState,
    deleteAddressState,
    deletingAddressId,
    selectedLocation,
    selectedGovernorateId,
    selectedCityId,
    autoAddressDetails,
  ];
}
