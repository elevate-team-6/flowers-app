import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_snack_bar.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppStrings.address.tr()),
        ),
        body: BlocConsumer<AddressCubit, AddressStates>(
          listenWhen: (prev, curr) =>
              prev.addAddressState != curr.addAddressState ||
              prev.updateAddressState != curr.updateAddressState ||
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

    final currentActionState =
        state.addAddressState.isLoading ||
            state.addAddressState.data == true ||
            state.addAddressState.errorMessage != null
        ? state.addAddressState
        : state.updateAddressState;

    if (currentActionState.data == true) {
      Navigator.pop(context, true);
    } else if (currentActionState.errorMessage != null) {
      CustomSnackBar.showErrorMessage(currentActionState.errorMessage!);
    }
  }

  Widget _buildSaveButton(BuildContext context, AddressStates state) {
    final bool isLoading =
        state.addAddressState.isLoading || state.updateAddressState.isLoading;

    return Padding(
      padding: EdgeInsets.all(24.r),
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _saveAddress(context, state),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                widget.addressToEdit == null
                    ? AppStrings.saveAddress.tr()
                    : AppStrings.updateAddress.tr(),
              ),
      ),
    );
  }

  Future<void> _openMapPicker(BuildContext context) async {
    final cubit = context.read<AddressCubit>();
    final LatLng? result =
        await Navigator.pushNamed(
              context,
              AppRoutes.mapPicker,
              arguments:
                  cubit.state.selectedLocation ??
                  const LatLng(
                    AppConstants.defaultLatitude,
                    AppConstants.defaultLongitude,
                  ),
            )
            as LatLng?;

    if (result != null) {
      cubit.doEvent(MapLocationPickedEvent(result));
    }
  }

  void _saveAddress(BuildContext context, AddressStates state) {
    if (_formKey.currentState!.validate()) {
      if (state.selectedGovernorateId == null || state.selectedCityId == null) {
        CustomSnackBar.showErrorMessage(
          AppStrings.pleaseSelectCityAndArea.tr(),
        );
        return;
      }

      if (state.selectedLocation == null && widget.addressToEdit == null) {
        CustomSnackBar.showErrorMessage(
          AppStrings.pleaseSelectLocationOnMap.tr(),
        );
        return;
      }

      context.read<AddressCubit>().doEvent(
        widget.addressToEdit == null
            ? AddAddressEvent(
                recipientName: _nameController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
                street: _addressController.text.trim(),
              )
            : UpdateAddressEvent(
                id: widget.addressToEdit?.id,
                recipientName: _nameController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
                street: _addressController.text.trim(),
              ),
      );
    }
  }
}
