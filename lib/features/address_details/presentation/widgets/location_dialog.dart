import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_cubit.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationDialog extends StatelessWidget {
  final bool permissionDeniedForever;

  const LocationDialog({super.key, this.permissionDeniedForever = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.locationRequired.tr()),
      content: Text(
        permissionDeniedForever
            ? AppStrings.locationPermissionDenied.tr()
            : AppStrings.enableLocationServices.tr(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.later.tr()),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);

            if (permissionDeniedForever) {
              await Geolocator.openAppSettings();
            } else {
              await Geolocator.openLocationSettings();
            }

            if (!context.mounted) return;

            context.read<AddressDetailsCubit>().doEvent(
              ValidateLocationEvent(),
            );
          },
          child: Text(
            permissionDeniedForever
                ? AppStrings.openSettings.tr()
                : AppStrings.enableLocation.tr(),
          ),
        ),
      ],
    );
  }
}
