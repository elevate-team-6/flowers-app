import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_cubit.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_event.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/custom_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressCard extends StatelessWidget {
  final String addressName;
  final String address;
  final bool isSelected;
  final VoidCallback onTap;
  const AddressCard({
    super.key,
    required this.addressName,
    required this.isSelected,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),

          boxShadow: [
            BoxShadow(
              color: AppColors.white90.withValues(alpha: 0.12),
              blurRadius: 4,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      CustomRadioButton(isSelected: isSelected),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          addressName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.black12400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  Text(
                    address,
                    style: AppTextStyles.gray12400,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.addAddressScreen,
                );

                if (!context.mounted) return;

                if (result == true) {
                  context.read<AddressCubit>().doEvent(GetAddressesEvent());

                  context.read<AddressDetailsCubit>().doEvent(
                    InitializeAddressDetailsEvent(),
                  );
                }
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
