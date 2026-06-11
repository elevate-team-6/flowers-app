import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/get_addresses_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/get_default_address_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/set_default_address_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeDefaultAddressUseCase {
  final GetAddressesUseCase _getAddressesUseCase;
  final GetDefaultAddressUseCase _getDefaultAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  InitializeDefaultAddressUseCase(
    this._getAddressesUseCase,
    this._getDefaultAddressUseCase,
    this._setDefaultAddressUseCase,
  );

  Future<BaseResponse<AddressEntity?>> call() async {
    final defaultResponse = await _getDefaultAddressUseCase();

    switch (defaultResponse) {
      case SuccessBaseResponse<AddressEntity?>():
        if (defaultResponse.data != null) {
          return defaultResponse;
        }
        break;

      case ErrorBaseResponse<AddressEntity?>():
        return ErrorBaseResponse(defaultResponse.errorMessage);
    }

    final addressesResponse = await _getAddressesUseCase();

    switch (addressesResponse) {
      case SuccessBaseResponse<List<AddressEntity>>():
        final addresses = addressesResponse.data;

        if (addresses.isEmpty) {
          return SuccessBaseResponse(null);
        }

        final address = addresses.first;

        await _setDefaultAddressUseCase(address, selectedByUser: false);

        return SuccessBaseResponse(address);

      case ErrorBaseResponse<List<AddressEntity>>():
        return ErrorBaseResponse(addressesResponse.errorMessage);
    }
  }
}