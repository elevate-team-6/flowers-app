import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:flowers_app/features/orders/domain/entities/order_item_entity.dart';
import 'package:flowers_app/features/orders/domain/use_cases/get_user_orders_use_case.dart';
import 'package:flowers_app/features/orders/presentation/view_model/orders_cubit.dart';
import 'package:flowers_app/features/orders/presentation/view_model/orders_event.dart';
import 'package:flowers_app/features/orders/presentation/view_model/orders_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_cubit_test.mocks.dart';

@GenerateMocks([GetUserOrdersUseCase])
void main() {
  late MockGetUserOrdersUseCase getUserOrdersUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<OrderEntity>>>(
      ErrorBaseResponse<List<OrderEntity>>('dummy'),
    );
  });

  setUp(() {
    getUserOrdersUseCase = MockGetUserOrdersUseCase();
  });

  OrdersCubit buildCubit() => OrdersCubit(getUserOrdersUseCase);

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

  const orderItemEntity = OrderItemEntity(
    id: 'item1',
    product: productEntity,
    price: 250,
    quantity: 2,
  );

  final orderEntity = OrderEntity(
    id: 'order1',
    userId: 'user1',
    orderNumber: '12345',
    items: const [orderItemEntity],
    totalPrice: 500,
    paymentType: 'cash',
    isPaid: false,
    isDelivered: false,
    state: OrderStatus.pending,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
    updatedAt: DateTime.parse('2024-01-02T00:00:00.000'),
  );

  group('GetUserOrdersEvent', () {
    blocTest<OrdersCubit, OrdersState>(
      'emits [loading, success] when GetUserOrdersEvent succeeds',
      setUp: () {
        when(
          getUserOrdersUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse([orderEntity]));
      },
      build: buildCubit,
      act: (cubit) => cubit.doEvent(const GetUserOrdersEvent()),
      expect: () => [
        const OrdersState(status: OrdersStatus.loading),
        OrdersState(status: OrdersStatus.success, orders: [orderEntity]),
      ],
      verify: (_) => verify(getUserOrdersUseCase()).called(1),
    );

    blocTest<OrdersCubit, OrdersState>(
      'emits [loading, failure] when GetUserOrdersEvent fails',
      setUp: () {
        when(
          getUserOrdersUseCase(),
        ).thenAnswer((_) async => ErrorBaseResponse('Error'));
      },
      build: buildCubit,
      act: (cubit) => cubit.doEvent(const GetUserOrdersEvent()),
      expect: () => [
        const OrdersState(status: OrdersStatus.loading),
        const OrdersState(status: OrdersStatus.failure, errorMessage: 'Error'),
      ],
      verify: (_) => verify(getUserOrdersUseCase()).called(1),
    );
  });
}
