import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
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
    this._selectDefaultAddressUseCase,
    this._validateLocationUseCase,
  ) : super(const AddressDetailsState());

  final InitializeDefaultAddressUseCase _initializeUseCase;
  final SelectDefaultAddressUseCase _selectDefaultAddressUseCase;
  final ValidateDeliveryLocationUseCase _validateLocationUseCase;

  Future<void> doEvent(AddressDetailsEvent event) async {
    switch (event) {
      case InitializeAddressDetailsEvent():
        await _initialize();
      case RefreshAddressDetailsEvent():
        await _refreshDefaultAddress();
      case SelectAddressEvent():
        await _selectAddress(event.address);

      case ValidateLocationEvent():
        await _validateLocation();
    }
  }

  Future<void> _initialize() async {
    emit(
      state.copyWith(
        status: AddressDetailsStatus.loading,
        defaultAddressState: const BaseState(isLoading: true),
      ),
    );

    final response = await _initializeUseCase();

    switch (response) {
      case SuccessBaseResponse<AddressEntity?>():
        emit(
          state.copyWith(
            status: response.data == null
                ? AddressDetailsStatus.noAddresses
                : AddressDetailsStatus.success,
            defaultAddressState: BaseState(data: response.data),
          ),
        );

      case ErrorBaseResponse<AddressEntity?>():
        emit(
          state.copyWith(
            status: AddressDetailsStatus.error,
            defaultAddressState: BaseState(errorMessage: response.errorMessage),
          ),
        );
    }
  }

  Future<void> _refreshDefaultAddress() async {
    await _initialize();
  }

  Future<void> _selectAddress(AddressEntity address) async {
    emit(
      state.copyWith(
        defaultAddressState: BaseState(
          data: state.defaultAddressState.data,
          isLoading: true,
        ),
      ),
    );

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
            defaultAddressState: BaseState(
              data: state.defaultAddressState.data,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _validateLocation() async {
    emit(state.copyWith(locationStatus: DeliveryLocationStatus.checking));

    final result = await _validateLocationUseCase();

    emit(state.copyWith(locationStatus: result));
  }
}
