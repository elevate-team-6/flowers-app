import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/config/di/di.dart';
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
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_cubit.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
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

  AddressCubit(
    this._getAddressesUseCase,
    this._addAddressUseCase,
    this._updateAddressUseCase,
    this._deleteAddressUseCase,
    this._getGovernoratesUseCase,
    this._getCitiesUseCase,
  ) : super(const AddressStates());
 void _refreshAddressDetails() {
  getIt<AddressDetailsCubit>().doEvent(
    InitializeAddressDetailsEvent(),
  );
}
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

    final double? lat = double.tryParse(address.latitude);
    final double? long = double.tryParse(address.longitude);

    emit(
      state.copyWith(
        selectedLocation: (lat != null && long != null)
            ? LatLng(lat, long)
            : null,
        autoAddressDetails: address.street,
      ),
    );

    // Match Governorate and City to select them in dropdowns
    final govs = state.governoratesState.data;
    if (govs != null) {
      try {
        final matchedGov = govs.firstWhere(
          (g) =>
              g.nameEn.toLowerCase() == address.city.toLowerCase() ||
              g.nameAr == address.city,
        );

        emit(state.copyWith(selectedGovernorateId: matchedGov.id));

        // 2. Load cities for this gov
        await _onGetCities(matchedGov.id);

        final cities = state.citiesState.data;
        if (cities != null) {
          try {
            final matchedCity = cities.firstWhere(
              (c) =>
                  c.nameEn.toLowerCase() == address.area.toLowerCase() ||
                  c.nameAr == address.area,
            );
            emit(state.copyWith(selectedCityId: matchedCity.id));
          } catch (_) {}
        }
      } catch (_) {}
    }
  }

  Future<void> _onGetAddresses() async {
    emit(state.copyWith(addressesState: const BaseState(isLoading: true)));
    final result = await _getAddressesUseCase();
    if (result is SuccessBaseResponse<List<AddressEntity>>) {
      emit(
        state.copyWith(
          addressesState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          addressesState: BaseState(
            isLoading: false,
            errorMessage: (result as ErrorBaseResponse).errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _onAddAddress(AddressEntity address) async {
    emit(state.copyWith(actionState: const BaseState(isLoading: true)));
    final result = await _addAddressUseCase(address);
    if (result is SuccessBaseResponse<List<AddressEntity>>) {
         _refreshAddressDetails();
      emit(
        state.copyWith(
          actionState: const BaseState(isLoading: false, data: true),
          addressesState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          actionState: BaseState(
            isLoading: false,
            errorMessage: (result as ErrorBaseResponse).errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _onUpdateAddress(AddressEntity address) async {
    emit(state.copyWith(actionState: const BaseState(isLoading: true)));
    final result = await _updateAddressUseCase(address);
    if (result is SuccessBaseResponse<List<AddressEntity>>) {
         _refreshAddressDetails();
      emit(
        state.copyWith(
          actionState: const BaseState(isLoading: false, data: true),
          addressesState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          actionState: BaseState(
            isLoading: false,
            errorMessage: (result as ErrorBaseResponse).errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _onDeleteAddress(String addressId) async {
    emit(state.copyWith(actionState: const BaseState(isLoading: true)));
    final result = await _deleteAddressUseCase(addressId);
    if (result is SuccessBaseResponse<List<AddressEntity>>) {
         _refreshAddressDetails();
      emit(
        state.copyWith(
          actionState: const BaseState(isLoading: false, data: true),
          addressesState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          actionState: BaseState(
            isLoading: false,
            errorMessage: (result as ErrorBaseResponse).errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _onGetGovernorates() async {
    emit(state.copyWith(governoratesState: const BaseState(isLoading: true)));
    final result = await _getGovernoratesUseCase();
    if (result is SuccessBaseResponse<List<GovernorateEntity>>) {
      emit(
        state.copyWith(
          governoratesState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          governoratesState: BaseState(
            isLoading: false,
            errorMessage: (result as ErrorBaseResponse).errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _onGetCities(String governorateId) async {
    emit(state.copyWith(citiesState: const BaseState(isLoading: true)));
    final result = await _getCitiesUseCase(governorateId);
    if (result is SuccessBaseResponse<List<CityEntity>>) {
      emit(
        state.copyWith(
          citiesState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          citiesState: BaseState(
            isLoading: false,
            errorMessage: (result as ErrorBaseResponse).errorMessage,
          ),
        ),
      );
    }
  }

  void _onGovernorateChanged(String? governorateId) {
    emit(
      state.copyWith(
        selectedGovernorateId: governorateId,
        resetCity: true,
        citiesState: const BaseState(), // Clear previous cities
      ),
    );
    if (governorateId != null) {
      _onGetCities(governorateId);
    }
  }

  Future<void> _onMapLocationPicked(dynamic location) async {
    emit(state.copyWith(selectedLocation: location));
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final streetAddress =
            "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}";

        String? matchedGovId;
        String? matchedCityId;

        if (state.governoratesState.data != null) {
          try {
            final matchedGov = state.governoratesState.data!.firstWhere(
              (gov) =>
                  place.administrativeArea?.toLowerCase().contains(
                    gov.nameEn.toLowerCase(),
                  ) ??
                  false,
            );
            matchedGovId = matchedGov.id;

            // Always fetch cities if we found a governorate to enable the Area dropdown
            emit(
              state.copyWith(
                selectedGovernorateId: matchedGovId,
                citiesState: const BaseState(isLoading: true),
              ),
            );

            final citiesResult = await _getCitiesUseCase(matchedGovId);
            if (citiesResult is SuccessBaseResponse<List<CityEntity>>) {
              try {
                matchedCityId = citiesResult.data
                    .firstWhere(
                      (city) =>
                          (place.subAdministrativeArea?.toLowerCase().contains(
                                city.nameEn.toLowerCase(),
                              ) ??
                              false) ||
                          (place.locality?.toLowerCase().contains(
                                city.nameEn.toLowerCase(),
                              ) ??
                              false) ||
                          (place.subLocality?.toLowerCase().contains(
                                city.nameEn.toLowerCase(),
                              ) ??
                              false),
                    )
                    .id;
              } catch (_) {}

              emit(
                state.copyWith(
                  autoAddressDetails: streetAddress,
                  selectedCityId: matchedCityId,
                  citiesState: BaseState(
                    isLoading: false,
                    data: citiesResult.data,
                  ),
                ),
              );
              return; // Exit after successful update
            }
          } catch (_) {}
        }

        // Fallback if governorate not matched or cities fetch failed
        emit(
          state.copyWith(
            autoAddressDetails: streetAddress,
            selectedGovernorateId: matchedGovId,
            selectedCityId: matchedCityId,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
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
