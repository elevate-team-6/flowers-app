import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_cubit.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_event.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDeliveryAddressSection extends StatelessWidget {
  const HomeDeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressDetailsCubit, AddressDetailsState>(
      builder: (context, detailsState) {
        return BlocBuilder<AddressCubit, AddressStates>(
          builder: (context, addressState) {
            final selectedAddress = detailsState.defaultAddressState.data;

            final addresses =
                addressState.addressesState.data ?? <AddressEntity>[];

            final addressText = selectedAddress?.street ?? '';

            return Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.black50,
                  size: 20.sp,
                ),

                SizedBox(width: 4.w),

                Expanded(
                  child: selectedAddress == null
                      ? TextButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              AppRoutes.addAddressScreen,
                            );

                            if (!context.mounted) return;

                            context.read<AddressCubit>().doEvent(
                              GetAddressesEvent(),
                            );

                            context.read<AddressDetailsCubit>().doEvent(
                              InitializeAddressDetailsEvent(),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(
                            AppStrings.addNewAddress.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Text(
                          '${AppStrings.deliverTo.tr()} $addressText',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.black50,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),

                if (addresses.length > 1)
                  PopupMenuButton<AddressEntity>(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                    onSelected: (address) {
                      context.read<AddressDetailsCubit>().doEvent(
                        SelectAddressEvent(address),
                      );
                    },
                    itemBuilder: (context) {
                      return addresses.map((address) {
                        return PopupMenuItem<AddressEntity>(
                          value: address,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  address.street,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (selectedAddress?.id == address.id)
                                const Icon(Icons.check, size: 18),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
