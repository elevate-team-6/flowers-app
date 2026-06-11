import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_events.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_states.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutAddressesSection extends StatelessWidget {
  final CheckoutStates state;

  const CheckoutAddressesSection({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.deliveryAddress.tr(),
          style: AppTextStyles.black18500,
        ),
        ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.addressesState.data?.length ?? 0,
          separatorBuilder: (_, _) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final address = state.addressesState.data![index];

            return AddressCard(
              addressName: address.street,
              address: '${address.street}, ${address.city}',
              isSelected: state.selectedAddress?.id == address.id,
              onTap: () {
                context.read<CheckoutCubit>().doEvent(
                  SelectAddressEvent(address),
                );
              },
            );
          },
        ),
      ],
    );
  }
}