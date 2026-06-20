import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_error_state_view.dart';
import 'package:flowers_app/core/widgets/custom_snack_bar.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flowers_app/features/address/presentation/widgets/address_item_card.dart';
import 'package:flowers_app/features/address/presentation/widgets/empty_addresses_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AddressCubit>()..doEvent(const GetAddressesEvent()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppStrings.savedAddress.tr()),
        ),
        body: const _SavedAddressesListener(child: _SavedAddressesBody()),
        bottomNavigationBar: const _AddAddressButton(),
      ),
    );
  }
}

class _SavedAddressesListener extends StatelessWidget {
  final Widget child;
  const _SavedAddressesListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressStates>(
      listenWhen: (prev, curr) =>
          prev.deleteAddressState != curr.deleteAddressState,
      listener: (context, state) {
        if (state.deleteAddressState.data == true) {
          CustomSnackBar.showSuccessMessage(
            AppStrings.addressDeletedSuccess.tr(),
          );
        } else if (state.deleteAddressState.errorMessage != null) {
          CustomSnackBar.showErrorMessage(
            state.deleteAddressState.errorMessage!,
          );
        }
      },
      child: child,
    );
  }
}

class _SavedAddressesBody extends StatelessWidget {
  const _SavedAddressesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressStates>(
      buildWhen: (prev, curr) => prev.addressesState != curr.addressesState,
      builder: (context, state) {
        if (state.addressesState.isLoading) {
          return Center(
            child: SizedBox(
              width: 150.w,
              height: 150.h,
              child: Lottie.asset(AppLottie.flowerLoading),
            ),
          );
        }

        if (state.addressesState.errorMessage != null) {
          return CustomErrorStateView(
            message: state.addressesState.errorMessage!,
            onRetry: () =>
                context.read<AddressCubit>().doEvent(const GetAddressesEvent()),
          );
        }

        final addresses = state.addressesState.data ?? [];

        if (addresses.isEmpty) {
          return const EmptyAddressesView();
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final address = addresses[index];
            return AddressItemCard(
              address: address,
              isDeleting: state.deletingAddressId == address.id,
              onDelete: () => context.read<AddressCubit>().doEvent(
                DeleteAddressEvent(address.id!),
              ),
              onEdit: () => _onEditAddress(context, address),
            );
          },
        );
      },
    );
  }

  Future<void> _onEditAddress(BuildContext context, address) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.addAddressScreen,
      arguments: address,
    );
    if (result == true && context.mounted) {
      CustomSnackBar.showSuccessMessage(AppStrings.addressUpdatedSuccess.tr());
      context.read<AddressCubit>().doEvent(const GetAddressesEvent());
    }
  }
}

class _AddAddressButton extends StatelessWidget {
  const _AddAddressButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.addAddressScreen,
          );
          if (result == true && context.mounted) {
            CustomSnackBar.showSuccessMessage(
              AppStrings.addressAddedSuccess.tr(),
            );
            context.read<AddressCubit>().doEvent(const GetAddressesEvent());
          }
        },
        child: Text(AppStrings.addNewAddress.tr()),
      ),
    );
  }
}
