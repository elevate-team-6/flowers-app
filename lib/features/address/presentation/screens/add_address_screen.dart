import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/presentation/screens/map_picker_screen.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flowers_app/features/address/presentation/widgets/add_address_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class AddAddressScreen extends StatefulWidget {
  final AddressEntity? addressToEdit;
  const AddAddressScreen({super.key, this.addressToEdit});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nameController;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(
      text: widget.addressToEdit?.street,
    );
    _phoneController = TextEditingController(
      text: widget.addressToEdit?.phoneNumber,
    );
    _nameController = TextEditingController(
      text: widget.addressToEdit?.recipientName,
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<AddressCubit>()
          ..doEvent(const GetGovernoratesEvent());
        if (widget.addressToEdit != null) {
          cubit.doEvent(InitEditAddressEvent(widget.addressToEdit!));
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppStrings.address.tr(), style: AppTextStyles.black18600),
          centerTitle: false,
        ),
        body: BlocConsumer<AddressCubit, AddressStates>(
          listenWhen: (prev, curr) =>
              prev.actionState != curr.actionState ||
              prev.autoAddressDetails != curr.autoAddressDetails ||
              prev.selectedLocation != curr.selectedLocation,
          listener: _handleStateChanges,
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.r),
                    child: AddAddressFormFields(
                      formKey: _formKey,
                      addressController: _addressController,
                      phoneController: _phoneController,
                      nameController: _nameController,
                      mapController: _mapController,
                      state: state,
                      isAr:
                          context.locale.languageCode ==
                          AppConstants.arabicCode,
                      onMapTap: () => _openMapPicker(context),
                    ),
                  ),
                ),
                _buildSaveButton(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, AddressStates state) {
    if (state.autoAddressDetails != null) {
      _addressController.text = state.autoAddressDetails!;
    }

    if (state.selectedLocation != null) {
      _mapController.move(state.selectedLocation!, AppConstants.defaultMapZoom);
    }

    if (state.actionState.isLoading) {
      LoadingDialog.show(context: context);
    } else {
      LoadingDialog.hide(context: context);
    }

    if (state.actionState.data == true) {
      Navigator.pop(context, true);
    } else if (state.actionState.errorMessage != null) {
      SnackBarServices.showErrorMessage(state.actionState.errorMessage!);
    }
  }

  Widget _buildSaveButton(BuildContext context, AddressStates state) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
            elevation: 0,
          ),
          onPressed: () => _saveAddress(context, state),
          child: Text(
            widget.addressToEdit == null
                ? AppStrings.saveAddress.tr()
                : AppStrings.updateAddress.tr(),
            style: AppTextStyles.white16600,
          ),
        ),
      ),
    );
  }

  Future<void> _openMapPicker(BuildContext context) async {
    final cubit = context.read<AddressCubit>();
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(
          initialLocation:
              cubit.state.selectedLocation ??
              const LatLng(
                AppConstants.defaultLatitude,
                AppConstants.defaultLongitude,
              ),
        ),
      ),
    );
    if (result != null) {
      cubit.doEvent(MapLocationPickedEvent(result));
    }
  }

  void _saveAddress(BuildContext context, AddressStates state) {
    if (_formKey.currentState!.validate()) {
      if (state.selectedGovernorateId == null || state.selectedCityId == null) {
        SnackBarServices.showErrorMessage(
          AppStrings.pleaseSelectCityAndArea.tr(),
        );
        return;
      }

      if (state.selectedLocation == null && widget.addressToEdit == null) {
        SnackBarServices.showErrorMessage(
          AppStrings.pleaseSelectLocationOnMap.tr(),
        );
        return;
      }

      final gov = state.governoratesState.data!.firstWhere(
        (e) => e.id == state.selectedGovernorateId,
      );
      final city = state.citiesState.data!.firstWhere(
        (e) => e.id == state.selectedCityId,
      );

      final address = AddressEntity(
        id: widget.addressToEdit?.id,
        recipientName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        street: _addressController.text.trim(),
        city: gov.nameEn,
        area: city.nameEn,
        latitude:
            (state.selectedLocation?.latitude ??
                    double.tryParse(widget.addressToEdit?.latitude ?? '0.0') ??
                    0.0)
                .toString(),
        longitude:
            (state.selectedLocation?.longitude ??
                    double.tryParse(widget.addressToEdit?.longitude ?? '0.0') ??
                    0.0)
                .toString(),
      );

      context.read<AddressCubit>().doEvent(
        widget.addressToEdit == null
            ? AddAddressEvent(address)
            : UpdateAddressEvent(address),
      );
    }
  }
}
