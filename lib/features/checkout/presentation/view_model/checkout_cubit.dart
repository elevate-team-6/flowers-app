import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';
import 'package:flowers_app/features/checkout/domain/use_cases/card_checkout_use_case.dart';
import 'package:flowers_app/features/checkout/domain/use_cases/cash_checkout_use_case.dart';
import 'package:flowers_app/features/checkout/domain/use_cases/get_delivery_dayes_use_case.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_events.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutStates> {
  CheckoutCubit(
    this._cardCheckoutUseCase,
    this._cashCheckoutUseCase,
    this._getDeliveryDaysUseCase,
  ) : super(const CheckoutStates());

  final CashCheckoutUseCase _cashCheckoutUseCase;
  final CardCheckoutUseCase _cardCheckoutUseCase;
  final GetDeliveryDaysUseCase _getDeliveryDaysUseCase;

  Future<void> doEvent(CheckoutEvent event) async {
    switch (event) {
      case SelectAddressEvent():
        _selectAddress(event.address);
        return;

      case SelectPaymentMethodEvent():
        _selectPaymentMethod(event.paymentMethod);
        return;

      case CashCheckoutEvent():
        return _cashCheckout(event.request);

      case CardCheckoutEvent():
        return _cardCheckout(event.cartId, event.request);

      case ToggleGiftEvent():
        _toggleGift(event.isGift);
        return;
      case LoadDeliveryDaysEvent():
        _loadDeliveryDays();
        return;
    }
  }

  Future<void> _cashCheckout(CheckoutRequest request) async {
    emit(
      state.copyWith(
        cashCheckoutState: state.cashCheckoutState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    final response = await _cashCheckoutUseCase(request);

    switch (response) {
      case SuccessBaseResponse<OrderEntity>():
        emit(
          state.copyWith(
            cashCheckoutState: state.cashCheckoutState.copyWith(
              isLoading: false,
              data: response.data,
            ),
          ),
        );

      case ErrorBaseResponse<OrderEntity>():
        emit(
          state.copyWith(
            cashCheckoutState: state.cashCheckoutState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _cardCheckout(String cartId, CheckoutRequest request) async {
    emit(
      state.copyWith(
        cardCheckoutState: state.cardCheckoutState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    final response = await _cardCheckoutUseCase(cartId, request);

    switch (response) {
      case SuccessBaseResponse<CardEntity>():
        emit(
          state.copyWith(
            cardCheckoutState: state.cardCheckoutState.copyWith(
              isLoading: false,
              data: response.data,
            ),
          ),
        );
      case ErrorBaseResponse<CardEntity>():
        emit(
          state.copyWith(
            cardCheckoutState: state.cardCheckoutState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  void _selectAddress(AddressEntity address) {
    emit(state.copyWith(selectedAddress: address));
  }

  void _selectPaymentMethod(String paymentMethod) {
    emit(
      state.copyWith(
        selectedPaymentMethod: paymentMethod,
        isGift: paymentMethod == AppConstants.card ? state.isGift : false,
      ),
    );
  }

  void _toggleGift(bool isGift) {
    emit(state.copyWith(isGift: isGift));
  }

  void _loadDeliveryDays() {
    emit(state.copyWith(deliveryDays: _getDeliveryDaysUseCase()));
  }
}
