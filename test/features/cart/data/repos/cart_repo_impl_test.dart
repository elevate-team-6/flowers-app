import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/data/data_sources/cart_remote_data_source_contract.dart';
import 'package:flowers_app/features/cart/data/models/response/cart_response.dart';
import 'package:flowers_app/features/cart/data/repos/cart_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_repo_impl_test.mocks.dart';

@GenerateMocks([CartRemoteDataSourceContract])
void main() {
  late MockCartRemoteDataSourceContract dataSource;
  late CartRepoImpl repo;

  setUpAll(() {
    provideDummy<BaseResponse<CartResponse>>(
      ErrorBaseResponse<CartResponse>('dummy'),
    );
  });

  setUp(() {
    dataSource = MockCartRemoteDataSourceContract();
    repo = CartRepoImpl(dataSource);
  });

  const cartResponse = CartResponse(message: 'success', numOfCartItems: 0);

  group('getCart', () {
    test('returns SuccessBaseResponse with entity when success', () async {
      when(
        dataSource.getCart(),
      ).thenAnswer((_) async => SuccessBaseResponse(cartResponse));

      final result = await repo.getCart();

      expect(result, isA<SuccessBaseResponse>());
      verify(dataSource.getCart()).called(1);
    });

    test('returns ErrorBaseResponse when failure', () async {
      when(
        dataSource.getCart(),
      ).thenAnswer((_) async => ErrorBaseResponse('Error'));

      final result = await repo.getCart();

      expect(result, isA<ErrorBaseResponse>());
      expect((result as ErrorBaseResponse).errorMessage, 'Error');
    });
  });

  group('addToCart', () {
    test('returns SuccessBaseResponse with entity when success', () async {
      when(
        dataSource.addToCart('p1', 1),
      ).thenAnswer((_) async => SuccessBaseResponse(cartResponse));

      final result = await repo.addToCart('p1', 1);

      expect(result, isA<SuccessBaseResponse>());
      verify(dataSource.addToCart('p1', 1)).called(1);
    });

    test('returns ErrorBaseResponse when failure', () async {
      when(
        dataSource.addToCart('p1', 1),
      ).thenAnswer((_) async => ErrorBaseResponse('Error'));

      final result = await repo.addToCart('p1', 1);

      expect(result, isA<ErrorBaseResponse>());
    });
  });

  group('updateQuantity', () {
    test('returns SuccessBaseResponse with entity when success', () async {
      when(
        dataSource.updateQuantity('p1', 2),
      ).thenAnswer((_) async => SuccessBaseResponse(cartResponse));

      final result = await repo.updateQuantity('p1', 2);

      expect(result, isA<SuccessBaseResponse>());
      verify(dataSource.updateQuantity('p1', 2)).called(1);
    });

    test('returns ErrorBaseResponse when failure', () async {
      when(
        dataSource.updateQuantity('p1', 2),
      ).thenAnswer((_) async => ErrorBaseResponse('Error'));

      final result = await repo.updateQuantity('p1', 2);

      expect(result, isA<ErrorBaseResponse>());
    });
  });

  group('removeItem', () {
    test('returns SuccessBaseResponse with entity when success', () async {
      when(
        dataSource.removeItem('p1'),
      ).thenAnswer((_) async => SuccessBaseResponse(cartResponse));

      final result = await repo.removeItem('p1');

      expect(result, isA<SuccessBaseResponse>());
      verify(dataSource.removeItem('p1')).called(1);
    });

    test('returns ErrorBaseResponse when failure', () async {
      when(
        dataSource.removeItem('p1'),
      ).thenAnswer((_) async => ErrorBaseResponse('Error'));

      final result = await repo.removeItem('p1');

      expect(result, isA<ErrorBaseResponse>());
    });
  });

  group('clearCart', () {
    test('returns SuccessBaseResponse with entity when success', () async {
      when(
        dataSource.clearCart(),
      ).thenAnswer((_) async => SuccessBaseResponse(cartResponse));

      final result = await repo.clearCart();

      expect(result, isA<SuccessBaseResponse>());
      verify(dataSource.clearCart()).called(1);
    });

    test('returns ErrorBaseResponse when failure', () async {
      when(
        dataSource.clearCart(),
      ).thenAnswer((_) async => ErrorBaseResponse('Error'));

      final result = await repo.clearCart();

      expect(result, isA<ErrorBaseResponse>());
    });
  });
}
