import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flowers_app/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_addresses_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_cities_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_governorates_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/update_address_use_case.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_service.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class AddressCubit extends Cubit<AddressStates> {
  final GetAddressesUseCase _getAddressesUseCase;
  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final AddressService _addressService;

  AddressCubit(
    this._getAddressesUseCase,
    this._addAddressUseCase,
    this._updateAddressUseCase,
    this._deleteAddressUseCase,
    this._getGovernoratesUseCase,
    this._getCitiesUseCase,
    this._addressService,
  ) : super(const AddressStates());

  void doEvent(AddressEvent event) {
    switch (event) {
      case GetAddressesEvent():
        _onGetAddresses();
      case AddAddressEvent():
        _onAddAddress(event.address);
      case UpdateAddressEvent():
        _onUpdateAddress(event.address);
      case DeleteAddressEvent():
        _onDeleteAddress(event.addressId);
      case GetGovernoratesEvent():
        _onGetGovernorates();
      case GetCitiesEvent():
        _onGetCities(event.governorateId);
      case MapLocationPickedEvent():
        _onMapLocationPicked(event.location);
      case GovernorateChangedEvent():
        _onGovernorateChanged(event.governorateId);
      case CityChangedEvent():
        emit(state.copyWith(selectedCityId: event.cityId));
      case InitEditAddressEvent():
        _onInitEditAddress(event.address);
    }
  }

  Future<void> _onInitEditAddress(AddressEntity address) async {
    // 1. Ensure governorates are loaded
    if (state.governoratesState.data == null) {
      await _onGetGovernorates();
    }

    final govs = state.governoratesState.data;
    if (govs == null) return;

    // 2. Local variables to hold data before single emit
    String? matchedGovId;
    String? matchedCityId;
    List<CityEntity>? cities;

    // Match Governorate
    matchedGovId = _addressService.matchGovernorate(govs, address.city);

    if (matchedGovId != null) {
      // Load cities for this gov
      final citiesResult = await _getCitiesUseCase(matchedGovId);
      if (citiesResult is SuccessBaseResponse<List<CityEntity>>) {
        cities = citiesResult.data;
        // Match City
        matchedCityId = _addressService.matchCityByName(cities, address.area);
      }
    }

    // 3. Single Emit for everything (Efficiency)
    final double? lat = double.tryParse(address.latitude);
    final double? long = double.tryParse(address.longitude);

    emit(
      state.copyWith(
        selectedLocation: (lat != null && long != null)
            ? LatLng(lat, long)
            : null,
        autoAddressDetails: address.street,
        selectedGovernorateId: matchedGovId,
        selectedCityId: matchedCityId,
        citiesState: cities != null
            ? BaseState(isLoading: false, data: cities)
            : state.citiesState,
      ),
    );
  }

  Future<void> _onGetAddresses() async {
    emit(state.copyWith(addressesState: const BaseState(isLoading: true)));
    final result = await _getAddressesUseCase();

    emit(switch (result) {
      SuccessBaseResponse<List<AddressEntity>>() => state.copyWith(
        addressesState: BaseState(isLoading: false, data: result.data),
      ),
      ErrorBaseResponse<List<AddressEntity>>() => state.copyWith(
        addressesState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      ),
    });
  }

  Future<void> _onAddAddress(AddressEntity address) async {
    emit(state.copyWith(actionState: const BaseState(isLoading: true)));
    final result = await _addAddressUseCase(address);

    emit(switch (result) {
      SuccessBaseResponse<List<AddressEntity>>() => state.copyWith(
        actionState: const BaseState(isLoading: false, data: true),
        addressesState: BaseState(isLoading: false, data: result.data),
      ),
      ErrorBaseResponse<List<AddressEntity>>() => state.copyWith(
        actionState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      ),
    });
  }

  Future<void> _onUpdateAddress(AddressEntity address) async {
    emit(state.copyWith(actionState: const BaseState(isLoading: true)));
    final result = await _updateAddressUseCase(address);

    emit(switch (result) {
      SuccessBaseResponse<List<AddressEntity>>() => state.copyWith(
        actionState: const BaseState(isLoading: false, data: true),
        addressesState: BaseState(isLoading: false, data: result.data),
      ),
      ErrorBaseResponse<List<AddressEntity>>() => state.copyWith(
        actionState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      ),
    });
  }

  Future<void> _onDeleteAddress(String addressId) async {
    emit(state.copyWith(actionState: const BaseState(isLoading: true)));
    final result = await _deleteAddressUseCase(addressId);

    emit(switch (result) {
      SuccessBaseResponse<List<AddressEntity>>() => state.copyWith(
        actionState: const BaseState(isLoading: false, data: true),
        addressesState: BaseState(isLoading: false, data: result.data),
      ),
      ErrorBaseResponse<List<AddressEntity>>() => state.copyWith(
        actionState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      ),
    });
  }

  Future<void> _onGetGovernorates() async {
    emit(state.copyWith(governoratesState: const BaseState(isLoading: true)));
    final result = await _getGovernoratesUseCase();

    emit(switch (result) {
      SuccessBaseResponse<List<GovernorateEntity>>() => state.copyWith(
        governoratesState: BaseState(isLoading: false, data: result.data),
      ),
      ErrorBaseResponse<List<GovernorateEntity>>() => state.copyWith(
        governoratesState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      ),
    });
  }

  Future<void> _onGetCities(String governorateId) async {
    emit(state.copyWith(citiesState: const BaseState(isLoading: true)));
    final result = await _getCitiesUseCase(governorateId);

    emit(switch (result) {
      SuccessBaseResponse<List<CityEntity>>() => state.copyWith(
        citiesState: BaseState(isLoading: false, data: result.data),
      ),
      ErrorBaseResponse<List<CityEntity>>() => state.copyWith(
        citiesState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      ),
    });
  }

  void _onGovernorateChanged(String? governorateId) {
    emit(
      state.copyWith(
        selectedGovernorateId: governorateId,
        resetCity: true,
        citiesState: const BaseState(),
      ),
    );
    if (governorateId != null) {
      _onGetCities(governorateId);
    }
  }

  Future<void> _onMapLocationPicked(LatLng location) async {
    // 1. Initial emit for location and loading state
    emit(
      state.copyWith(
        selectedLocation: location,
        citiesState: const BaseState(isLoading: true),
      ),
    );

    try {
      // 2. Get Placemark from Service (Architecture: Cubit doesn't talk to Geocoding)
      final place = await _addressService.getPlacemarkFromLocation(location);
      if (place == null) throw Exception("Could not find address");

      final streetAddress = _addressService.formatPlacemark(place);

      String? matchedGovId;
      String? matchedCityId;
      List<CityEntity>? cities;

      // 3. Match Governorate
      if (state.governoratesState.data != null) {
        matchedGovId = _addressService.matchGovernorate(
          state.governoratesState.data!,
          place.administrativeArea,
        );

        if (matchedGovId != null) {
          // 4. Load Cities
          final citiesResult = await _getCitiesUseCase(matchedGovId);
          if (citiesResult is SuccessBaseResponse<List<CityEntity>>) {
            cities = citiesResult.data;
            matchedCityId = _addressService.matchCity(cities, place);
          }
        }
      }

      emit(
        state.copyWith(
          autoAddressDetails: streetAddress,
          selectedGovernorateId: matchedGovId,
          selectedCityId: matchedCityId,
          citiesState: BaseState(isLoading: false, data: cities),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          citiesState: const BaseState(isLoading: false),
          actionState: BaseState(isLoading: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  void resetActionState() {
    emit(
      state.copyWith(
        actionState: const BaseState(),
        autoAddressDetails: null,
        selectedLocation: null,
        selectedGovernorateId: null,
        selectedCityId: null,
      ),
    );
  }
}
