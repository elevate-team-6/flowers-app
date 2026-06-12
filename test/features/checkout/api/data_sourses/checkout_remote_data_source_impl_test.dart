import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/services/remote_config_service.dart';
import 'package:flowers_app/features/checkout/api/checkout_api_client/checkout_api_client.dart';
import 'package:flowers_app/features/checkout/api/data_sourses/checkout_remote_data_source_impl.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_model.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/cash_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/order_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'checkout_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CheckoutApiClient, RemoteConfigService])
void main() {
  late CheckoutRemoteDataSourceImpl remoteDataSource;
  late MockCheckoutApiClient mockApiClient;
  late MockRemoteConfigService mockRemoteConfig;

  const dummyOrderModel = OrderModel(
    id: '1',
    userId: 'user_1',
    totalPrice: 100,
    paymentType: 'cash',
    isPaid: false,
    isDelivered: false,
    state: 'pending',
    orderNumber: 'ORD-001',
  );

  const dummyCardModel = CardModel(
    id: '1',
    paymentStatus: 'pending',
    status: 'active',
    url: 'https://test.com',
  );

  setUp(() {
    mockApiClient = MockCheckoutApiClient();
    mockRemoteConfig = MockRemoteConfigService();

    remoteDataSource = CheckoutRemoteDataSourceImpl(
      mockApiClient,
      mockRemoteConfig,
    );
  });

  group('CheckoutRemoteDataSourceImpl', () {
    test(
      'cashCheckout should return SuccessBaseResponse<CashCheckoutResponse>',
      () async {
        final request = CheckoutRequest(
          street: 'street',
          phone: '01010101010',
          city: 'Giza',
          lat: '0',
          long: '0',
        );

        final dummyResponse = CashCheckoutResponse(
          message: 'success',
          order: dummyOrderModel,
        );

        when(
          mockApiClient.cashCheckout(request),
        ).thenAnswer((_) async => dummyResponse);

        final result = await remoteDataSource.cashCheckout(request);

        expect(result, isA<SuccessBaseResponse<CashCheckoutResponse>>());

        verify(mockApiClient.cashCheckout(request)).called(1);
      },
    );

    test(
      'cardCheckout should return SuccessBaseResponse<CardCheckoutResponse>',
      () async {
        const cartId = 'cartId';

        final request = CheckoutRequest(
          street: 'street',
          phone: '01010101010',
          city: 'Giza',
          lat: '0',
          long: '0',
        );

        final dummyResponse = CardCheckoutResponse(
          message: 'success',
          session: dummyCardModel,
        );

        when(
          mockApiClient.cardCheckout(any, request),
        ).thenAnswer((_) async => dummyResponse);

        final result = await remoteDataSource.cardCheckout(cartId, request);

        expect(result, isA<SuccessBaseResponse<CardCheckoutResponse>>());

        verify(mockApiClient.cardCheckout(any, request)).called(1);
      },
    );
  });
}
