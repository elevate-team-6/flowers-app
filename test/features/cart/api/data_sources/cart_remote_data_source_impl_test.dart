import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/api/api_client/cart_api_client.dart';
import 'package:flowers_app/features/cart/api/data_sources/cart_remote_data_source_impl.dart';
import 'package:flowers_app/features/cart/data/models/request/add_to_cart_request.dart';
import 'package:flowers_app/features/cart/data/models/request/update_quantity_request.dart';
import 'package:flowers_app/features/cart/data/models/response/cart_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CartApiClient])
void main() {
  late MockCartApiClient apiClient;
  late CartRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = MockCartApiClient();
    dataSource = CartRemoteDataSourceImpl(apiClient);
  });

  const cartResponse = CartResponse(message: 'success', numOfCartItems: 0);

  group('getCart', () {
    test('returns SuccessBaseResponse when API call succeeds', () async {
      when(apiClient.getCart()).thenAnswer((_) async => cartResponse);

      final result = await dataSource.getCart();

      expect(result, isA<SuccessBaseResponse<CartResponse>>());
      expect((result as SuccessBaseResponse).data, cartResponse);
      verify(apiClient.getCart()).called(1);
    });

    test('returns ErrorBaseResponse when API call throws', () async {
      when(apiClient.getCart()).thenThrow(Exception('error'));

      final result = await dataSource.getCart();

      expect(result, isA<ErrorBaseResponse<CartResponse>>());
    });
  });

  group('addToCart', () {
    test('returns SuccessBaseResponse when API call succeeds', () async {
      when(apiClient.addToCart(any)).thenAnswer((_) async => cartResponse);

      final result = await dataSource.addToCart('p1', 1);

      expect(result, isA<SuccessBaseResponse<CartResponse>>());
      verify(apiClient.addToCart(argThat(isA<AddToCartRequest>()))).called(1);
    });

    test('returns ErrorBaseResponse when API call throws', () async {
      when(apiClient.addToCart(any)).thenThrow(Exception('error'));

      final result = await dataSource.addToCart('p1', 1);

      expect(result, isA<ErrorBaseResponse<CartResponse>>());
    });
  });

  group('updateQuantity', () {
    test('returns SuccessBaseResponse when API call succeeds', () async {
      when(
        apiClient.updateQuantity(any, any),
      ).thenAnswer((_) async => cartResponse);

      final result = await dataSource.updateQuantity('p1', 2);

      expect(result, isA<SuccessBaseResponse<CartResponse>>());
      verify(
        apiClient.updateQuantity('p1', argThat(isA<UpdateQuantityRequest>())),
      ).called(1);
    });

    test('returns ErrorBaseResponse when API call throws', () async {
      when(apiClient.updateQuantity(any, any)).thenThrow(Exception('error'));

      final result = await dataSource.updateQuantity('p1', 2);

      expect(result, isA<ErrorBaseResponse<CartResponse>>());
    });
  });

  group('removeItem', () {
    test('returns SuccessBaseResponse when API call succeeds', () async {
      when(apiClient.removeItem('p1')).thenAnswer((_) async => cartResponse);

      final result = await dataSource.removeItem('p1');

      expect(result, isA<SuccessBaseResponse<CartResponse>>());
      verify(apiClient.removeItem('p1')).called(1);
    });

    test('returns ErrorBaseResponse when API call throws', () async {
      when(apiClient.removeItem('p1')).thenThrow(Exception('error'));

      final result = await dataSource.removeItem('p1');

      expect(result, isA<ErrorBaseResponse<CartResponse>>());
    });
  });

  group('clearCart', () {
    test('returns SuccessBaseResponse when API call succeeds', () async {
      when(apiClient.clearCart()).thenAnswer((_) async => cartResponse);

      final result = await dataSource.clearCart();

      expect(result, isA<SuccessBaseResponse<CartResponse>>());
      verify(apiClient.clearCart()).called(1);
    });

    test('returns ErrorBaseResponse when API call throws', () async {
      when(apiClient.clearCart()).thenThrow(Exception('error'));

      final result = await dataSource.clearCart();

      expect(result, isA<ErrorBaseResponse<CartResponse>>());
    });
  });
}
