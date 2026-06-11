import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class AddressMapPreview extends StatelessWidget {
  final LatLng? selectedLocation;
  final LatLng initialPosition;
  final MapController mapController;
  final VoidCallback onTap;

  const AddressMapPreview({
    super.key,
    required this.selectedLocation,
    required this.initialPosition,
    required this.mapController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.white60),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: initialPosition,
                  initialZoom: AppConstants.defaultMapZoom,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: AppConstants.mapUrlTemplate,
                    userAgentPackageName: AppConstants.mapUserAgent,
                  ),
                  if (selectedLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: selectedLocation!,
                          width: 40.r,
                          height: 40.r,
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.error,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              // Gradient or overlay if needed, but the image is clean.
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(
                      0,
                    ), // Ensure it captures taps
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
