import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/services/location_service.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_addresses_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/find_nearest_address_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/set_default_address_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class AutoSelectNearestAddressUseCase {
  final GetAddressesUseCase _getAddressesUseCase;
  final FindNearestAddressUseCase _findNearestAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;
  final LocationService _locationService;

  AutoSelectNearestAddressUseCase(
    this._getAddressesUseCase,
    this._findNearestAddressUseCase,
    this._setDefaultAddressUseCase,
    this._locationService,
  );

  Future<BaseResponse<AddressEntity?>> call() async {
    final addressesResponse = await _getAddressesUseCase();

    switch (addressesResponse) {
      case SuccessBaseResponse<List<AddressEntity>>():
        final addresses = addressesResponse.data;

        if (addresses.isEmpty) {
          return SuccessBaseResponse(null);
        }

        Position position;

        try {
          position = await _locationService.getCurrentPosition();
        } catch (e) {
          return ErrorBaseResponse(e.toString());
        }

        final nearestAddress = _findNearestAddressUseCase(
          currentPosition: position,
          addresses: addresses,
        );

        if (nearestAddress == null) {
          return SuccessBaseResponse(null);
        }

        final saveResponse = await _setDefaultAddressUseCase(
          nearestAddress,
          selectedByUser: false,
        );

        switch (saveResponse) {
          case SuccessBaseResponse<void>():
            return SuccessBaseResponse(nearestAddress);

          case ErrorBaseResponse<void>():
            return ErrorBaseResponse(saveResponse.errorMessage);
        }

      case ErrorBaseResponse<List<AddressEntity>>():
        return ErrorBaseResponse(addressesResponse.errorMessage);
    }
  }
}
