import 'package:flowers_app/config/services/location_service.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class ValidateDeliveryLocationUseCase {
  final LocationService _locationService;

  ValidateDeliveryLocationUseCase(this._locationService);

  Future<DeliveryLocationStatus> call() async {
    final isEnabled = await _locationService.isLocationServiceEnabled();

    if (!isEnabled) {
      return DeliveryLocationStatus.locationDisabled;
    }

    var permission = await _locationService.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await _locationService.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return DeliveryLocationStatus.permissionDenied;
    }

    if (permission == LocationPermission.deniedForever) {
      return DeliveryLocationStatus.permissionDeniedForever;
    }

    return DeliveryLocationStatus.enabled;
  }
}
