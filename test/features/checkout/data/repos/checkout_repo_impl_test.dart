import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
import 'package:flowers_app/features/checkout/data/data_sources/checkout_remote_data_source_contract.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_model.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/cash_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/order_model.dart';
import 'package:flowers_app/features/checkout/data/repos/checkout_repo_impl.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'checkout_repo_impl_test.mocks.dart';

@GenerateMocks([
  CheckoutRemoteDataSourceContract,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
])
void main() {
  late CheckoutRepoImpl repo;
  late MockCheckoutRemoteDataSourceContract remoteDataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;

  setUpAll(() {
    provideDummy<BaseResponse<AddressResponse>>(
      SuccessBaseResponse(AddressResponse(message: '', addresses: [])),
    );

    provideDummy<BaseResponse<CashCheckoutResponse>>(
      SuccessBaseResponse(
        CashCheckoutResponse(
          message: '',
          order: const OrderModel(
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
          session:
              const CardModel(id: '', paymentStatus: '', status: '', url: ''),
        ),
      ),
    );
  });

  setUp(() {
    remoteDataSource = MockCheckoutRemoteDataSourceContract();
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();

    repo = CheckoutRepoImpl(remoteDataSource, mockFirestore);
  });

  group('cashCheckout', () {
    test('should return OrderEntity and save to Firestore', () async {
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

      // Setup Firestore mocks
      when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.set(any)).thenAnswer((_) async => {});

      when(remoteDataSource.cashCheckout(any)).thenAnswer(
        (_) async => SuccessBaseResponse(
          CashCheckoutResponse(message: 'success', order: order),
        ),
      );

      final result = await repo.cashCheckout(
        const CheckoutRequest(
          street: 'street',
          phone: '010',
          city: 'giza',
          lat: '0',
          long: '0',
        ),
      );

      expect(result, isA<SuccessBaseResponse<OrderEntity>>());

      // Verify Firestore calls
      verify(mockFirestore.collection(AppConstants.ordersCollection)).called(1);
      verify(mockCollectionReference.doc(order.id)).called(1);
      verify(
        mockDocumentReference.set({
          AppConstants.orderIdField: order.id,
          AppConstants.orderNumberField: order.orderNumber,
          AppConstants.userIdField: order.userId,
          AppConstants.statusField: 'pending',
          AppConstants.riderIdField: null,
          AppConstants.riderNameField: null,
          AppConstants.riderPhoneField: null,
        }),
      ).called(1);

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
        const CheckoutRequest(
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
