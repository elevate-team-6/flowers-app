import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flowers_app/features/address/presentation/widgets/pick_location_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

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

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;

    bool isDefaultLocation =
        widget.initialLocation.latitude == AppConstants.defaultLatitude &&
        widget.initialLocation.longitude == AppConstants.defaultLongitude;

    if (isDefaultLocation) {
      context.read<AddressCubit>().doEvent(const GetCurrentLocationEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressStates>(
      listenWhen: (previous, current) =>
          previous.currentLocationState != current.currentLocationState,
      listener: (context, state) {
        if (state.currentLocationState.data != null) {
          final currentLatLng = state.currentLocationState.data!;
          setState(() {
            _pickedLocation = currentLatLng;
          });
          _mapController.move(currentLatLng, 15);
        }
      },
      child: Scaffold(
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
            BlocBuilder<AddressCubit, AddressStates>(
              buildWhen: (previous, current) =>
                  previous.currentLocationState.isLoading !=
                  current.currentLocationState.isLoading,
              builder: (context, state) {
                if (state.currentLocationState.isLoading) {
                  return Container(
                    color: AppColors.black.withValues(alpha: 0.3),
                    child: const Center(child: LoadingDialog()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned(
              bottom: 24.h,
              right: 24.w,
              child: FloatingActionButton(
                onPressed: () => context.read<AddressCubit>().doEvent(
                  const GetCurrentLocationEvent(),
                ),
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
