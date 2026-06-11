import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_service.dart';
import 'package:flowers_app/features/address/presentation/widgets/pick_location_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../../config/di/di.dart';
import '../../../../core/widgets/custom_flower_loading.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng initialLocation;

  const MapPickerScreen({
    super.key,
    this.initialLocation = const LatLng(
      AppConstants.defaultLatitude,
      AppConstants.defaultLongitude,
    ),
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _pickedLocation;
  final MapController _mapController = MapController();
  bool _isLoadingCurrentLocation = false;
  final AddressService _addressService = getIt<AddressService>();

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;

    bool isDefaultLocation =
        widget.initialLocation.latitude == AppConstants.defaultLatitude &&
        widget.initialLocation.longitude == AppConstants.defaultLongitude;

    if (isDefaultLocation) {
      _determinePosition(moveToLocation: true);
    }
  }

  Future<void> _determinePosition({bool moveToLocation = true}) async {
    setState(() => _isLoadingCurrentLocation = true);

    final currentLatLng = await _addressService.getCurrentLocation();

    if (mounted) {
      if (currentLatLng != null) {
        setState(() {
          _pickedLocation = currentLatLng;
          _isLoadingCurrentLocation = false;
        });
        if (moveToLocation) {
          _mapController.move(currentLatLng, 15);
        }
      } else {
        setState(() => _isLoadingCurrentLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.selectLocationOnMap.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _pickedLocation),
          ),
        ],
      ),
      body: Stack(
        children: [
          PickLocationMap(
            mapController: _mapController,
            initialLocation: widget.initialLocation,
            pickedLocation: _pickedLocation,
            onTap: (tapPosition, latLng) {
              setState(() {
                _pickedLocation = latLng;
              });
            },
          ),
          if (_isLoadingCurrentLocation)
            Container(
              color: AppColors.black.withValues(alpha: 0.3),
              child: const Center(child: LoadingDialog()),
            ),
          Positioned(
            bottom: 24.h,
            right: 24.w,
            child: FloatingActionButton(
              onPressed: () => _determinePosition(moveToLocation: true),
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
