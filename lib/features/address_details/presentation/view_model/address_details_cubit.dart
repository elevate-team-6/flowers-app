import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_addresses_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/initialize_default_address_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/select_default_address_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/validate_delivery_location_use_case.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_event.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class AddressDetailsCubit extends Cubit<AddressDetailsState> {
  AddressDetailsCubit(
    this._initializeUseCase,
    this._getAddressesUseCase,
    this._selectDefaultAddressUseCase,
    this._validateLocationUseCase,
  ) : super(const AddressDetailsState());

  final InitializeDefaultAddressUseCase _initializeUseCase;
  final GetAddressesUseCase _getAddressesUseCase;
  final SelectDefaultAddressUseCase _selectDefaultAddressUseCase;
  final ValidateDeliveryLocationUseCase _validateLocationUseCase;

  Future<void> doEvent(AddressDetailsEvent event) async {
    switch (event) {
      case InitializeAddressDetailsEvent():
        await _initialize();

      case RefreshAddressDetailsEvent():
        await refreshAddresses();

      case SelectAddressEvent():
        await _selectAddress(event.address);

      case ValidateLocationEvent():
        await _validateLocation();
    }
  }

  Future<void> _validateLocation() async {
    emit(state.copyWith(locationStatus: DeliveryLocationStatus.checking));

    final result = await _validateLocationUseCase();

    emit(state.copyWith(locationStatus: result));
  }

  Future<void> _initialize() async {
    emit(
      state.copyWith(
        status: AddressDetailsStatus.loading,
        defaultAddressState: const BaseState(isLoading: true),
      ),
    );

    final addressesResponse = await _getAddressesUseCase();

    switch (addressesResponse) {
      case SuccessBaseResponse<List<AddressEntity>>():
        final addresses = addressesResponse.data;

        if (addresses.isEmpty) {
          emit(
            state.copyWith(
              status: AddressDetailsStatus.noAddresses,
              addresses: const [],
              defaultAddressState: const BaseState(),
            ),
          );

          return;
        }

        final defaultResponse = await _initializeUseCase();

        switch (defaultResponse) {
          case SuccessBaseResponse<AddressEntity?>():
            emit(
              state.copyWith(
                addresses: addresses,
                status: AddressDetailsStatus.success,
                defaultAddressState: BaseState(data: defaultResponse.data),
              ),
            );

          case ErrorBaseResponse<AddressEntity?>():
            emit(
              state.copyWith(
                addresses: addresses,
                status: AddressDetailsStatus.error,
                defaultAddressState: BaseState(
                  errorMessage: defaultResponse.errorMessage,
                ),
              ),
            );
        }

      case ErrorBaseResponse<List<AddressEntity>>():
        emit(
          state.copyWith(
            status: AddressDetailsStatus.error,
            defaultAddressState: BaseState(
              errorMessage: addressesResponse.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> refreshAddresses() async {
    final addressesResponse = await _getAddressesUseCase();

    switch (addressesResponse) {
      case SuccessBaseResponse<List<AddressEntity>>():
        final addresses = addressesResponse.data;

        if (addresses.isEmpty) {
          emit(
            state.copyWith(
              status: AddressDetailsStatus.noAddresses,
              addresses: const [],
              defaultAddressState: const BaseState(),
            ),
          );

          return;
        }

        AddressEntity? selectedAddress = state.defaultAddressState.data;

        if (selectedAddress != null) {
          final exists = addresses.any((e) => e.id == selectedAddress!.id);

          if (!exists) {
            selectedAddress = addresses.first;
          }
        } else {
          selectedAddress = addresses.first;
        }

        emit(
          state.copyWith(
            status: AddressDetailsStatus.success,
            addresses: addresses,
            defaultAddressState: BaseState(data: selectedAddress),
          ),
        );

      case ErrorBaseResponse<List<AddressEntity>>():
        emit(
          state.copyWith(
            status: AddressDetailsStatus.error,
            defaultAddressState: BaseState(
              errorMessage: addressesResponse.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _selectAddress(AddressEntity address) async {
    final response = await _selectDefaultAddressUseCase(address);

    switch (response) {
      case SuccessBaseResponse<void>():
        emit(
          state.copyWith(
            status: AddressDetailsStatus.success,
            defaultAddressState: BaseState(data: address),
          ),
        );

      case ErrorBaseResponse<void>():
        emit(
          state.copyWith(
            status: AddressDetailsStatus.error,
            defaultAddressState: BaseState(errorMessage: response.errorMessage),
          ),
        );
    }
  }
}
