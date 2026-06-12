import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/orders/api/api_client/orders_api_client.dart';
import 'package:flowers_app/features/orders/api/data_sources/orders_remote_data_source_impl.dart';
import 'package:flowers_app/features/orders/data/models/response/orders_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OrdersApiClient])
void main() {
  late MockOrdersApiClient apiClient;
  late OrdersRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = MockOrdersApiClient();
    dataSource = OrdersRemoteDataSourceImpl(apiClient);
  });

  const ordersResponse = OrdersResponse(message: 'success', orders: []);

  group('getUserOrders', () {
    test('returns SuccessBaseResponse when API call succeeds', () async {
      when(apiClient.getUserOrders()).thenAnswer((_) async => ordersResponse);

      final result = await dataSource.getUserOrders();

      expect(result, isA<SuccessBaseResponse<OrdersResponse>>());
      expect((result as SuccessBaseResponse).data, ordersResponse);
      verify(apiClient.getUserOrders()).called(1);
    });

    test(
      'returns ErrorBaseResponse with message when API call throws',
      () async {
        when(apiClient.getUserOrders()).thenThrow(Exception('error'));

        final result = await dataSource.getUserOrders();

        expect(result, isA<ErrorBaseResponse<OrdersResponse>>());
        expect((result as ErrorBaseResponse).errorMessage, isNotEmpty);
      },
    );
  });
}
