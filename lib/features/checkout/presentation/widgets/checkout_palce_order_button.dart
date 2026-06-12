import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_events.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPlaceOrderButton extends StatelessWidget {
  final CheckoutStates state;
  final CartEntity cart;
  final GlobalKey<FormState> formKey;

  const CheckoutPlaceOrderButton({
    super.key,
    required this.state,
    required this.cart,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading =
        state.cashCheckoutState.isLoading || state.cardCheckoutState.isLoading;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              if (state.selectedAddress == null) {
                SnackBarServices.showErrorMessage(
                  AppStrings.selectAddressFirst.tr(),
                );
                return;
              }

              if (state.selectedPaymentMethod == null) {
                SnackBarServices.showErrorMessage(
                  AppStrings.selectPaymentMethod.tr(),
                );
                return;
              }

              if (state.isGift && !formKey.currentState!.validate()) {
                return;
              }

              final address = state.selectedAddress!;

              final request = CheckoutRequest(
                street: address.street,
                city: address.city,
                phone: address.phoneNumber,
                lat: address.latitude,
                long: address.longitude,
              );

              if (state.selectedPaymentMethod == AppConstants.cash) {
                context.read<CheckoutCubit>().doEvent(
                  CashCheckoutEvent(request),
                );
              } else {
                context.read<CheckoutCubit>().doEvent(
                  CardCheckoutEvent(cartId: cart.id, request: request),
                );
              }
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(AppStrings.placeOrder.tr()),
    );
  }
}
