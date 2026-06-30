import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_snack_bar.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_cubit.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_event.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_events.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_states.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/checkout_addresses_section.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/checkout_delivery_section.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/checkout_order_summary.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/checkout_palce_order_button.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/checkout_payment_section.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/gift_section.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatefulWidget {
  final CartEntity cart;
  const CheckoutScreen({super.key, required this.cart});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  @override
  void initState() {
    super.initState();

    context.read<CheckoutCubit>().doEvent(LoadDeliveryDaysEvent());

    context.read<AddressCubit>().doEvent(GetAddressesEvent());

    context.read<AddressDetailsCubit>().doEvent(
      InitializeAddressDetailsEvent(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    return BlocListener<CheckoutCubit, CheckoutStates>(
      listenWhen: (previous, current) =>
          previous.cashCheckoutState != current.cashCheckoutState ||
          previous.cardCheckoutState != current.cardCheckoutState,
      listener: (context, state) async {
        final error =
            state.cardCheckoutState.errorMessage ??
            state.cashCheckoutState.errorMessage;
        if (error != null) {
          CustomSnackBar.showErrorMessage(error);
          return;
        }
        if (state.cashCheckoutState.data != null) {
          context.read<CartBloc>().add(const ClearCartEvent());

          CustomSnackBar.showSuccessMessage(
            AppStrings.paymentCompletedSuccessfully.tr(),
          );

          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.mainLayout,
            (route) => false,
          );
        }
        if (state.cardCheckoutState.data != null) {
          context.read<CartBloc>().add(const ClearCartEvent());
          final result =
              await Navigator.pushNamed(
                    context,
                    AppRoutes.paymentWebView,
                    arguments: state.cardCheckoutState.data!.url,
                  )
                  as PaymentResult?;
          switch (result) {
            case PaymentResult.success:
              CustomSnackBar.showSuccessMessage(
                AppStrings.paymentCompletedSuccessfully.tr(),
              );
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.mainLayout,
                (route) => false,
              );
              return;
            case PaymentResult.cancelled:
              CustomSnackBar.showErrorMessage(
                AppStrings.paymentWasCancelled.tr(),
              );
            case PaymentResult.noInternet:
              CustomSnackBar.showErrorMessage(
                AppStrings.noInternetConnection.tr(),
              );
            case PaymentResult.backPressed:
              CustomSnackBar.showErrorMessage(
                AppStrings.paymentWasNotCompleted.tr(),
              );
            default:
              break;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.checkout.tr()),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        body: BlocBuilder<CheckoutCubit, CheckoutStates>(
          builder: (context, state) {
            state.cashCheckoutState.isLoading ||
                state.cardCheckoutState.isLoading;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CheckoutDeliverySection(deliveryDays: state.deliveryDays),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(
                        height: 24,
                        thickness: 24,
                        color: AppColors.gray10,
                      ),
                    ),
                    CheckoutAddressesSection(state: state),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.addAddressScreen,
                        );

                        if (!context.mounted) return;

                        if (result == true) {
                          context.read<AddressCubit>().doEvent(
                            GetAddressesEvent(),
                          );

                          context.read<AddressDetailsCubit>().doEvent(
                            InitializeAddressDetailsEvent(),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.addNew.tr(),
                            style: AppTextStyles.primary14500,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(
                        height: 24,
                        thickness: 24,
                        color: AppColors.gray10,
                      ),
                    ),
                    CheckoutPaymentSection(state: state),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(
                        height: 24,
                        thickness: 24,
                        color: AppColors.gray10,
                      ),
                    ),
                    if (state.selectedPaymentMethod == AppConstants.card)
                      Form(
                        key: _formKey,
                        child: GiftSection(
                          isGift: state.isGift,
                          onChanged: (value) {
                            context.read<CheckoutCubit>().doEvent(
                              ToggleGiftEvent(value),
                            );
                          },
                          nameController: nameController,
                          phoneController: phoneController,
                        ),
                      ),

                    CheckoutOrderSummary(
                      subtotal: cart.subtotal,
                      deliveryFee: cart.deliveryFee,
                      total: cart.total,
                    ),
                    SizedBox(height: 50.h),
                    CheckoutPlaceOrderButton(
                      state: state,
                      cart: widget.cart,
                      formKey: _formKey,
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
