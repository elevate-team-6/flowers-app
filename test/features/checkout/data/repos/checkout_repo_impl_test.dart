import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/checkout/data/data_sources/checkout_remote_data_source_contract.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/address_response/adress_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_model.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/cash_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/order_model.dart';
import 'package:flowers_app/features/checkout/data/repos/checkout_repo_impl.dart';
import 'package:flowers_app/features/checkout/domain/entities/address_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'checkout_repo_impl_test.mocks.dart';

@GenerateMocks([CheckoutRemoteDataSourceContract])
void main() {
  late CheckoutRepoImpl repo;
  late MockCheckoutRemoteDataSourceContract remoteDataSource;
setUpAll(() {
  provideDummy<BaseResponse<AddressResponse>>(
    SuccessBaseResponse(
      AddressResponse(
        message: '',
        addresses: [],
      ),
    ),
  );

  provideDummy<BaseResponse<CashCheckoutResponse>>(
    SuccessBaseResponse(
      CashCheckoutResponse(
        message: '',
        order: OrderModel(
          id: '',
          userId: '',
          totalPrice: 0,
          paymentType: '',
          isPaid: false,
          isDelivered: false,
          state: '',
          orderNumber: '',
        ),
      ),
    ),
  );

  provideDummy<BaseResponse<CardCheckoutResponse>>(
    SuccessBaseResponse(
      CardCheckoutResponse(
        message: '',
        session: CardModel(
          id: '',
          paymentStatus: '',
          status: '',
          url: '',
        ),
      ),
    ),
  );
});
  setUp(() {
    remoteDataSource = MockCheckoutRemoteDataSourceContract();
    repo = CheckoutRepoImpl(remoteDataSource);
  });

  group('addresses', () {
    test('should return list of AddressEntity', () async {
      when(remoteDataSource.addresses()).thenAnswer(
        (_) async => SuccessBaseResponse(
          AddressResponse(message: 'success', addresses: []),
        ),
      );

      final result = await repo.addresses();

      expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());

      verify(remoteDataSource.addresses()).called(1);
    });
  });

  group('cashCheckout', () {
    test('should return OrderEntity', () async {
      const order = OrderModel(
        id: '1',
        userId: 'user_1',
        totalPrice: 100,
        paymentType: 'cash',
        isPaid: false,
        isDelivered: false,
        state: 'pending',
        orderNumber: 'ORD-001',
      );

      when(remoteDataSource.cashCheckout(any)).thenAnswer(
        (_) async => SuccessBaseResponse(
          CashCheckoutResponse(message: 'success', order: order),
        ),
      );

      final result = await repo.cashCheckout(
        CheckoutRequest(
          street: 'street',
          phone: '010',
          city: 'giza',
          lat: '0',
          long: '0',
        ),
      );

      expect(result, isA<SuccessBaseResponse<OrderEntity>>());

      verify(remoteDataSource.cashCheckout(any)).called(1);
    });
  });

  group('cardCheckout', () {
    test('should return CardEntity', () async {
      const card = CardModel(
        id: '1',
        paymentStatus: 'pending',
        status: 'active',
        url: 'https://test.com',
      );

      when(remoteDataSource.cardCheckout(any, any)).thenAnswer(
        (_) async => SuccessBaseResponse(
          CardCheckoutResponse(message: 'success', session: card),
        ),
      );

      final result = await repo.cardCheckout(
        'cartId',
        CheckoutRequest(
          street: 'street',
          phone: '010',
          city: 'giza',
          lat: '0',
          long: '0',
        ),
      );

      expect(result, isA<SuccessBaseResponse<CardEntity>>());

      verify(remoteDataSource.cardCheckout(any, any)).called(1);
    });
  });
}
