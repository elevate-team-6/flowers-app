import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_events.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_states.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPaymentSection extends StatelessWidget {
  final CheckoutStates state;

  const CheckoutPaymentSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.paymentMethod.tr(), style: AppTextStyles.black18500),
        const SizedBox(height: 20),

        if (!state.isGift)
          PaymentCard(
            isSelected: state.selectedPaymentMethod == AppConstants.cash,
            paymentMethodName: AppStrings.cashOnDelivery.tr(),
            onTap: () {
              context.read<CheckoutCubit>().doEvent(
                const SelectPaymentMethodEvent(AppConstants.cash),
              );
            },
          ),

        const SizedBox(height: 10),

        PaymentCard(
          isSelected: state.selectedPaymentMethod == AppConstants.card,
          paymentMethodName: AppStrings.creditCard.tr(),
          onTap: () {
            context.read<CheckoutCubit>().doEvent(
              const SelectPaymentMethodEvent(AppConstants.card),
            );
          },
        ),
      ],
    );
  }
}
