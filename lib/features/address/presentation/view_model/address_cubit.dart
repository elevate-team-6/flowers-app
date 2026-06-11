import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/extensions/placemark_extension.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flowers_app/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_addresses_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_cities_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_governorates_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_placemark_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/update_address_use_case.dart';
import 'package:flowers_app/features/address/domain/utils/address_matcher.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/use_cases/get_current_location_use_case.dart';

@singleton
class AddressCubit extends Cubit<AddressStates> {
  final GetAddressesUseCase _getAddressesUseCase;
  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetPlacemarkUseCase _getPlacemarkUseCase;
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final AddressMatcher _addressMatcher;

  AddressCubit(
    this._getAddressesUseCase,
    this._addAddressUseCase,
    this._updateAddressUseCase,
    this._deleteAddressUseCase,
    this._getGovernoratesUseCase,
    this._getCitiesUseCase,
    this._getPlacemarkUseCase,
    this._getCurrentLocationUseCase,
    this._addressMatcher,
  ) : super(const AddressStates());

  void doEvent(AddressEvent event) {
    switch (event) {
      case GetAddressesEvent():
        _onGetAddresses();
      case AddAddressEvent():
        _onAddAddress(
          recipientName: event.recipientName,
          phoneNumber: event.phoneNumber,
          street: event.street,
        );
      case UpdateAddressEvent():
        _onUpdateAddress(
          id: event.id,
          recipientName: event.recipientName,
          phoneNumber: event.phoneNumber,
          street: event.street,
        );
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
      case GetCurrentLocationEvent():
        _onGetCurrentLocation();
    }
  }

  Future<void> _onInitEditAddress(AddressEntity address) async {
    if (state.governoratesState.data == null) {
      await _onGetGovernorates();
    }

    final govs = state.governoratesState.data;
    if (govs == null) return;

    String? matchedGovId;
    String? matchedCityId;
    List<CityEntity>? cities;

    matchedGovId = _addressMatcher.matchGovernorate(govs, address.city);

    if (matchedGovId != null) {
      final citiesResult = await _getCitiesUseCase(matchedGovId);
      if (citiesResult is SuccessBaseResponse<List<CityEntity>>) {
        cities = citiesResult.data;
        matchedCityId = _addressMatcher.matchCityByName(cities, address.area);
      }
    }

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

  Future<void> _onAddAddress({
    required String recipientName,
    required String phoneNumber,
    required String street,
  }) async {
    emit(state.copyWith(addAddressState: const BaseState(isLoading: true)));

    final gov = state.governoratesState.data!.firstWhere(
      (e) => e.id == state.selectedGovernorateId,
    );
    final city = state.citiesState.data!.firstWhere(
      (e) => e.id == state.selectedCityId,
    );

    final address = AddressEntity(
      recipientName: recipientName,
      phoneNumber: phoneNumber,
      street: street,
      city: gov.nameEn,
      area: city.nameEn,
      latitude: (state.selectedLocation?.latitude ?? 0.0).toString(),
      longitude: (state.selectedLocation?.longitude ?? 0.0).toString(),
    );

    final result = await _addAddressUseCase(address);

    emit(switch (result) {
      SuccessBaseResponse<List<AddressEntity>>() => state.copyWith(
        addAddressState: const BaseState(isLoading: false, data: true),
        addressesState: BaseState(isLoading: false, data: result.data),
      ),
      ErrorBaseResponse<List<AddressEntity>>() => state.copyWith(
        addAddressState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      ),
    });
  }

  Future<void> _onUpdateAddress({
    String? id,
    required String recipientName,
    required String phoneNumber,
    required String street,
  }) async {
    emit(state.copyWith(updateAddressState: const BaseState(isLoading: true)));

    final gov = state.governoratesState.data!.firstWhere(
      (e) => e.id == state.selectedGovernorateId,
    );
    final city = state.citiesState.data!.firstWhere(
      (e) => e.id == state.selectedCityId,
    );

    final address = AddressEntity(
      id: id,
      recipientName: recipientName,
      phoneNumber: phoneNumber,
      street: street,
      city: gov.nameEn,
      area: city.nameEn,
      latitude: (state.selectedLocation?.latitude ?? 0.0).toString(),
      longitude: (state.selectedLocation?.longitude ?? 0.0).toString(),
    );

    final result = await _updateAddressUseCase(address);

    emit(switch (result) {
      SuccessBaseResponse<List<AddressEntity>>() => state.copyWith(
        updateAddressState: const BaseState(isLoading: false, data: true),
        addressesState: BaseState(isLoading: false, data: result.data),
      ),
      ErrorBaseResponse<List<AddressEntity>>() => state.copyWith(
        updateAddressState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
      ),
    });
  }

  Future<void> _onDeleteAddress(String addressId) async {
    emit(
      state.copyWith(
        deleteAddressState: const BaseState(isLoading: true),
        deletingAddressId: addressId,
      ),
    );
    final result = await _deleteAddressUseCase(addressId);

    emit(switch (result) {
      SuccessBaseResponse<List<AddressEntity>>() => state.copyWith(
        deleteAddressState: const BaseState(isLoading: false, data: true),
        addressesState: BaseState(isLoading: false, data: result.data),
        resetDeletingId: true,
      ),
      ErrorBaseResponse<List<AddressEntity>>() => state.copyWith(
        deleteAddressState: BaseState(
          isLoading: false,
          errorMessage: result.errorMessage,
        ),
        resetDeletingId: true,
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
    emit(
      state.copyWith(
        selectedLocation: location,
        citiesState: const BaseState(isLoading: true),
      ),
    );

    try {
      final place = await _getPlacemarkUseCase(location);
      if (place == null) {
        emit(
          state.copyWith(
            citiesState: const BaseState(isLoading: false),
            addAddressState: const BaseState(
              isLoading: false,
              errorMessage: AppStrings.locationFetchError,
            ),
          ),
        );
        return;
      }

      final streetAddress = place.formatAddress();

      String? matchedGovId;
      String? matchedCityId;
      List<CityEntity>? cities;

      if (state.governoratesState.data != null) {
        matchedGovId = _addressMatcher.matchGovernorate(
          state.governoratesState.data!,
          place.administrativeArea,
        );

        if (matchedGovId != null) {
          final citiesResult = await _getCitiesUseCase(matchedGovId);
          if (citiesResult is SuccessBaseResponse<List<CityEntity>>) {
            cities = citiesResult.data;
            matchedCityId = _addressMatcher.matchCity(cities, place);
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
          addAddressState: BaseState(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  void resetActionState() {
    emit(
      state.copyWith(
        addAddressState: const BaseState(),
        updateAddressState: const BaseState(),
        deleteAddressState: const BaseState(),
        currentLocationState: const BaseState(),
        resetAutoDetails: true,
        resetLocation: true,
        resetGovernorate: true,
        resetCity: true,
      ),
    );
  }

  Future<void> _onGetCurrentLocation() async {
    emit(
      state.copyWith(currentLocationState: const BaseState(isLoading: true)),
    );
    final result = await _getCurrentLocationUseCase();
    if (result != null) {
      emit(
        state.copyWith(
          currentLocationState: BaseState(isLoading: false, data: result),
          selectedLocation: result,
        ),
      );
    } else {
      emit(
        state.copyWith(
          currentLocationState: const BaseState(
            isLoading: false,
            errorMessage: AppStrings.locationFetchError,
          ),
        ),
      );
    }
  }
}
