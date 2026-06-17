import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_text_field.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flowers_app/features/address/presentation/widgets/address_map_preview.dart';
import 'package:flowers_app/features/address/presentation/widgets/address_selection_dropdowns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class AddAddressFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController nameController;
  final MapController mapController;
  final AddressStates state;
  final bool isAr;
  final VoidCallback onMapTap;

  const AddAddressFormFields({
    super.key,
    required this.formKey,
    required this.addressController,
    required this.phoneController,
    required this.nameController,
    required this.mapController,
    required this.state,
    required this.isAr,
    required this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddressMapPreview(
            selectedLocation: state.selectedLocation,
            initialPosition:
                state.selectedLocation ??
                const LatLng(30.0444, 31.2357), // Default
            mapController: mapController,
            onTap: onMapTap,
          ),
          SizedBox(height: 24.h),
          CustomTextField(
            controller: addressController,
            labelText: AppStrings.enterAddress.tr(),
            hintText: AppStrings.enterAddress.tr(),
            textInputAction: TextInputAction.next,
            validator: (val) =>
                AppValidations.required(val, AppStrings.enterAddress.tr()),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: phoneController,
            labelText: AppStrings.phoneNumber.tr(),
            hintText: AppStrings.enterPhoneNumber.tr(),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: AppValidations.validatePhoneNumber,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: nameController,
            labelText: AppStrings.recipientName.tr(),
            hintText: AppStrings.enterRecipientName.tr(),
            textInputAction: TextInputAction.done,
            validator: AppValidations.validateRecipientName,
          ),
          SizedBox(height: 16.h),
          AddressSelectionDropdowns(
            state: state,
            isAr: isAr,
            onGovernorateChanged: (val) => context.read<AddressCubit>().doEvent(
              GovernorateChangedEvent(val),
            ),
            onCityChanged: (val) =>
                context.read<AddressCubit>().doEvent(CityChangedEvent(val)),
          ),
        ],
      ),
    );
  }
}
