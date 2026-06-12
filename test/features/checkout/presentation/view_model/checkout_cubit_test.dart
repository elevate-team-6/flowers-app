import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';
import 'package:flowers_app/features/checkout/domain/use_cases/card_checkout_use_case.dart';
import 'package:flowers_app/features/checkout/domain/use_cases/cash_checkout_use_case.dart';
import 'package:flowers_app/features/checkout/domain/use_cases/get_delivery_dayes_use_case.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_events.dart';
import 'package:flowers_app/features/checkout/presentation/view_model/checkout_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'checkout_cubit_test.mocks.dart';

@GenerateMocks([
  CashCheckoutUseCase,
  CardCheckoutUseCase,
  GetDeliveryDaysUseCase,
])
void main() {
  late CheckoutCubit cubit;
  late MockCashCheckoutUseCase mockCashCheckoutUseCase;
  late MockCardCheckoutUseCase mockCardCheckoutUseCase;
  late MockGetDeliveryDaysUseCase mockGetDeliveryDaysUseCase;

  const address = AddressEntity(
    id: '1',
    street: 'Home',
    city: 'Giza',
    recipientName: '',
    phoneNumber: '',
    area: '',
    latitude: '',
    longitude: '',
  );

  const order = OrderEntity(
    id: '1',
    orderNumber: 'ORD-001',
    totalPrice: 100,
    paymentType: 'cash',
    state: 'pending',
  );

  const card = CardEntity(
    id: '1',
    paymentStatus: 'pending',
    status: 'active',
    url: 'https://test.com',
    successUrl: 'https://test.com/success',
    cancelUrl: 'https://test.com/cancel',
  );

  final request = CheckoutRequest(
    street: 'Home',
    phone: '01010101010',
    city: 'Giza',
    lat: '0',
    long: '0',
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse([address]),
    );

    provideDummy<BaseResponse<OrderEntity>>(SuccessBaseResponse(order));

    provideDummy<BaseResponse<CardEntity>>(SuccessBaseResponse(card));

    provideDummy<int>(2);

    provideDummy(
      CheckoutRequest(street: '', phone: '', city: '', lat: '', long: ''),
    );
  });

  setUp(() {
    mockCashCheckoutUseCase = MockCashCheckoutUseCase();
    mockCardCheckoutUseCase = MockCardCheckoutUseCase();
    mockGetDeliveryDaysUseCase = MockGetDeliveryDaysUseCase();

    when(mockGetDeliveryDaysUseCase()).thenReturn(2);

    cubit = CheckoutCubit(
      mockCardCheckoutUseCase,
      mockCashCheckoutUseCase,
      mockGetDeliveryDaysUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('CashCheckoutEvent', () {
    blocTest<CheckoutCubit, CheckoutStates>(
      'should checkout cash successfully',
      build: () {
        when(
          mockCashCheckoutUseCase(any),
        ).thenAnswer((_) async => SuccessBaseResponse(order));

        return cubit;
      },
      act: (cubit) => cubit.doEvent(CashCheckoutEvent(request)),
      verify: (_) {
        verify(mockCashCheckoutUseCase(any)).called(1);
      },
    );

    blocTest<CheckoutCubit, CheckoutStates>(
      'should emit error when cash checkout fails',
      build: () {
        when(
          mockCashCheckoutUseCase(any),
        ).thenAnswer((_) async => ErrorBaseResponse('error'));

        return cubit;
      },
      act: (cubit) => cubit.doEvent(CashCheckoutEvent(request)),
      verify: (_) {
        verify(mockCashCheckoutUseCase(any)).called(1);
      },
    );
  });

  group('CardCheckoutEvent', () {
    blocTest<CheckoutCubit, CheckoutStates>(
      'should checkout card successfully',
      build: () {
        when(
          mockCardCheckoutUseCase(any, any),
        ).thenAnswer((_) async => SuccessBaseResponse(card));

        return cubit;
      },
      act: (cubit) =>
          cubit.doEvent(CardCheckoutEvent(cartId: 'cart-id', request: request)),
      verify: (_) {
        verify(mockCardCheckoutUseCase(any, any)).called(1);
      },
    );

    blocTest<CheckoutCubit, CheckoutStates>(
      'should emit error when card checkout fails',
      build: () {
        when(
          mockCardCheckoutUseCase(any, any),
        ).thenAnswer((_) async => ErrorBaseResponse('error'));

        return cubit;
      },
      act: (cubit) =>
          cubit.doEvent(CardCheckoutEvent(cartId: 'cart-id', request: request)),
      verify: (_) {
        verify(mockCardCheckoutUseCase(any, any)).called(1);
      },
    );
  });

  group('Selection Events', () {
    test('should select address', () async {
      await cubit.doEvent(SelectAddressEvent(address));

      expect(cubit.state.selectedAddress, address);
    });

    test('should select payment method', () async {
      await cubit.doEvent(SelectPaymentMethodEvent(AppConstants.cash));

      expect(cubit.state.selectedPaymentMethod, AppConstants.cash);
    });

    test('should toggle gift', () async {
      await cubit.doEvent(ToggleGiftEvent(true));

      expect(cubit.state.isGift, true);
    });
  });
}
