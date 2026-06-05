import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/checkout/domain/entities/address_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';

class CheckoutStates extends Equatable {
  final BaseState<List<AddressEntity>> addressesState;
  final BaseState<OrderEntity> cashCheckoutState;
  final BaseState<CardEntity> cardCheckoutState;
  final AddressEntity? selectedAddress;
  final String? selectedPaymentMethod;
  final bool isGift;
  const CheckoutStates({
    this.addressesState = const BaseState(),
    this.cardCheckoutState = const BaseState(),
    this.cashCheckoutState = const BaseState(),
    this.selectedAddress,
    this.selectedPaymentMethod,
    this.isGift = false,
  });
  CheckoutStates copyWith({
    BaseState<List<AddressEntity>>? addressesState,
    BaseState<OrderEntity>? cashCheckoutState,
    BaseState<CardEntity>? cardCheckoutState,
    AddressEntity? selectedAddress,
    String? selectedPaymentMethod,
    final bool? isGift,
  }) {
    return CheckoutStates(
      addressesState: addressesState ?? this.addressesState,
      cardCheckoutState: cardCheckoutState ?? this.cardCheckoutState,
      cashCheckoutState: cashCheckoutState ?? this.cashCheckoutState,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      isGift: isGift ?? this.isGift,
    );
  }

  @override
  List<Object?> get props => [
    addressesState,
    cashCheckoutState,
    cardCheckoutState,
    selectedAddress,
    selectedPaymentMethod,
    isGift,
  ];
}
