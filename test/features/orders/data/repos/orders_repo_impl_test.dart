import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/orders/data/data_sources/orders_remote_data_source_contract.dart';
import 'package:flowers_app/features/orders/data/models/response/order_dto.dart';
import 'package:flowers_app/features/orders/data/models/response/order_item_dto.dart';
import 'package:flowers_app/features/orders/data/models/response/orders_response.dart';
import 'package:flowers_app/features/orders/data/repos/orders_repo_impl.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:flowers_app/features/orders/domain/entities/order_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_repo_impl_test.mocks.dart';

@GenerateMocks([OrdersRemoteDataSourceContract])
void main() {
  late MockOrdersRemoteDataSourceContract dataSource;
  late OrdersRepoImpl repo;

  setUpAll(() {
    provideDummy<BaseResponse<OrdersResponse>>(
      ErrorBaseResponse<OrdersResponse>('dummy'),
    );
  });

  setUp(() {
    dataSource = MockOrdersRemoteDataSourceContract();
    repo = OrdersRepoImpl(dataSource);
  });

  // Test data
  const productEntity = ProductEntity(
    id: 'p1',
    title: 'Rose',
    imgCover: '',
    price: 300,
    priceAfterDiscount: 250,
    discount: 50,
    description: 'Red rose',
  );

  const orderItemDto = OrderItemDto(
    id: 'item1',
    product: productEntity,
    price: 250,
    quantity: 2,
  );

  const orderDto = OrderDto(
    id: 'order1',
    user: 'user1',
    orderNumber: '12345',
    orderItems: [orderItemDto],
    totalPrice: 500,
    paymentType: 'cash',
    isPaid: false,
    isDelivered: false,
    state: 'pending',
    createdAt: '2024-01-01T00:00:00.000',
    updatedAt: '2024-01-02T00:00:00.000',
  );

  // Expected mapped entities
  const expectedOrderItem = OrderItemEntity(
    id: 'item1',
    product: productEntity,
    price: 250,
    quantity: 2,
  );

  final expectedOrder = OrderEntity(
    id: 'order1',
    userId: 'user1',
    orderNumber: '12345',
    items: const [expectedOrderItem],
    totalPrice: 500,
    paymentType: 'cash',
    isPaid: false,
    isDelivered: false,
    state: OrderStatus.pending,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
    updatedAt: DateTime.parse('2024-01-02T00:00:00.000'),
  );

  group('getUserOrders', () {
    test(
      'returns SuccessBaseResponse with mapped entities when success',
      () async {
        const ordersResponse = OrdersResponse(
          message: 'success',
          orders: [orderDto],
        );
        when(
          dataSource.getUserOrders(),
        ).thenAnswer((_) async => SuccessBaseResponse(ordersResponse));

        final result = await repo.getUserOrders();

        expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
        expect((result as SuccessBaseResponse<List<OrderEntity>>).data, [
          expectedOrder,
        ]);
        verify(dataSource.getUserOrders()).called(1);
      },
    );

    test('returns empty list when orders list is empty', () async {
      const ordersResponse = OrdersResponse(message: 'success', orders: []);
      when(
        dataSource.getUserOrders(),
      ).thenAnswer((_) async => SuccessBaseResponse(ordersResponse));

      final result = await repo.getUserOrders();

      expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
      expect((result as SuccessBaseResponse<List<OrderEntity>>).data, isEmpty);
      verify(dataSource.getUserOrders()).called(1);
    });

    test('returns ErrorBaseResponse with same message when failure', () async {
      when(
        dataSource.getUserOrders(),
      ).thenAnswer((_) async => ErrorBaseResponse('Error'));

      final result = await repo.getUserOrders();

      expect(result, isA<ErrorBaseResponse<List<OrderEntity>>>());
      expect((result as ErrorBaseResponse).errorMessage, 'Error');
      verify(dataSource.getUserOrders()).called(1);
    });
  });
}
