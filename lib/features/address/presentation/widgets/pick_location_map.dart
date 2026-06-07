import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/utils/app_colors.dart';

class PickLocationMap extends StatelessWidget {
  final MapController mapController;
  final LatLng initialLocation;
  final LatLng? pickedLocation;
  final Function(TapPosition, LatLng) onTap;

  const PickLocationMap({
    super.key,
    required this.mapController,
    required this.initialLocation,
    required this.pickedLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialLocation,
        initialZoom: 14,
        onTap: onTap,
      ),
      children: [
        TileLayer(
          urlTemplate: AppConstants.mapUrlTemplate,
          userAgentPackageName: AppConstants.mapUserAgent,
        ),
        if (pickedLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: pickedLocation!,
                width: 80.r,
                height: 80.r,
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.error,
                  size: 40,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
