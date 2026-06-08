import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/address/api/api_client/address_api_client.dart';
import 'package:flowers_app/features/address/api/data_sources/address_remote_data_source_impl.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([
  AddressApiClient,
  SecureCacheHelper,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late AddressRemoteDataSourceImpl dataSource;
  late MockAddressApiClient mockApiClient;
  late MockSecureCacheHelper mockCacheHelper;
  late MockFirebaseFirestore mockFirestore;

  // Firestore mocking helpers
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockCollectionReference<Map<String, dynamic>> mockNestedCollection;
  late MockDocumentReference<Map<String, dynamic>> mockNestedDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

  setUp(() {
    mockApiClient = MockAddressApiClient();
    mockCacheHelper = MockSecureCacheHelper();
    mockFirestore = MockFirebaseFirestore();
    dataSource = AddressRemoteDataSourceImpl(
      mockCacheHelper,
      mockApiClient,
      mockFirestore,
    );

    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    mockNestedCollection = MockCollectionReference();
    mockNestedDoc = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();

    // Setup the firestore chain
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    when(mockDoc.collection(any)).thenReturn(mockNestedCollection);
    when(mockNestedCollection.doc(any)).thenReturn(mockNestedDoc);
  });

  const tAddressModel = AddressModel(
    id: '1',
    username: 'John',
    phone: '0123',
    street: 'Street',
    city: 'City',
    lat: '0',
    long: '0',
  );

  final Map<String, dynamic> tAddressJson = {
    '_id': '1',
    'username': 'John',
    'phone': '0123',
    'street': 'Street',
    'city': 'City',
    'lat': '0',
    'long': '0',
  };

  final tAddressResponse = AddressResponse(addresses: [tAddressModel]);

  group('Address Remote Data Source Tests', () {
    group('getAddresses', () {
      test(
        'should return SuccessBaseResponse when API call is successful',
        () async {
          when(
            mockApiClient.getAddresses(),
          ).thenAnswer((_) async => tAddressResponse);

          final result = await dataSource.getAddresses();

          expect(result, isA<SuccessBaseResponse<AddressResponse>>());
          expect((result as SuccessBaseResponse).data, tAddressResponse);
          verify(mockApiClient.getAddresses()).called(1);
        },
      );

      test(
        'should return ErrorBaseResponse when API call throws exception',
        () async {
          when(mockApiClient.getAddresses()).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              error: 'Network Error',
              type: DioExceptionType.connectionError,
            ),
          );

          final result = await dataSource.getAddresses();

          expect(result, isA<ErrorBaseResponse<AddressResponse>>());
          // ErrorHandler returns a localized string, in tests it might return the key
          expect((result as ErrorBaseResponse).errorMessage, isNotNull);
        },
      );

      test(
        'should return ErrorBaseResponse when a network timeout occurs',
        () async {
          when(mockApiClient.getAddresses()).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              type: DioExceptionType.connectionTimeout,
            ),
          );

          final result = await dataSource.getAddresses();

          expect(result, isA<ErrorBaseResponse<AddressResponse>>());
          expect((result as ErrorBaseResponse).errorMessage, isNotNull);
        },
      );
    });

    group('updateAddress', () {
      test('should call update API and return success response', () async {
        when(
          mockApiClient.updateAddress(any, any),
        ).thenAnswer((_) async => tAddressResponse);

        final result = await dataSource.updateAddress(tAddressModel);

        expect(result, isA<SuccessBaseResponse<AddressResponse>>());
        verify(mockApiClient.updateAddress('1', tAddressModel)).called(1);
      });

      test('should return error when address model ID is null', () async {
        const noIdModel = AddressModel(username: 'John');
        final result = await dataSource.updateAddress(noIdModel);

        expect(result, isA<ErrorBaseResponse<AddressResponse>>());
        verifyNever(mockApiClient.updateAddress(any, any));
      });
    });

    group('deleteAddress', () {
      test(
        'should delete from API and also from Firestore if it was the default address',
        () async {
          // Arrange
          when(
            mockApiClient.deleteAddress(any),
          ).thenAnswer((_) async => tAddressResponse);
          when(
            mockCacheHelper.readData(key: AppKeys.userIdKey),
          ).thenAnswer((_) async => 'user123');
          when(mockNestedDoc.get(any)).thenAnswer((_) async => mockSnapshot);
          when(mockSnapshot.exists).thenReturn(true);
          when(
            mockSnapshot.data(),
          ).thenReturn({AppConstants.firestoreIdField: '1'});
          when(mockNestedDoc.delete()).thenAnswer((_) async => Future.value());

          // Act
          final result = await dataSource.deleteAddress('1');

          // Assert
          expect(result, isA<SuccessBaseResponse<AddressResponse>>());
          verify(mockApiClient.deleteAddress('1')).called(1);
          verify(mockNestedDoc.delete()).called(1);
        },
      );

      test(
        'should not call firestore delete if the deleted address was not the default one',
        () async {
          // Arrange
          when(
            mockApiClient.deleteAddress(any),
          ).thenAnswer((_) async => tAddressResponse);
          when(
            mockCacheHelper.readData(key: AppKeys.userIdKey),
          ).thenAnswer((_) async => 'user123');
          when(mockNestedDoc.get(any)).thenAnswer((_) async => mockSnapshot);
          when(mockSnapshot.exists).thenReturn(true);
          when(
            mockSnapshot.data(),
          ).thenReturn({AppConstants.firestoreIdField: '2'}); // Different ID

          // Act
          final result = await dataSource.deleteAddress('1');

          // Assert
          expect(result, isA<SuccessBaseResponse<AddressResponse>>());
          verify(mockApiClient.deleteAddress('1')).called(1);
          verifyNever(mockNestedDoc.delete());
        },
      );
    });

    group('Default Address Operations (Firestore)', () {
      test('should set default address in firestore successfully', () async {
        when(
          mockCacheHelper.readData(key: AppKeys.userIdKey),
        ).thenAnswer((_) async => 'user123');
        when(mockNestedDoc.set(any)).thenAnswer((_) async => Future.value());

        final result = await dataSource.setDefaultAddress(tAddressModel);

        expect(result, isA<SuccessBaseResponse<void>>());
        verify(
          mockNestedDoc.set({
            ...tAddressModel.toJson(),
            '_id': tAddressModel.id,
          }),
        ).called(1);
      });

      test(
        'should return ErrorBaseResponse when userId is missing from cache',
        () async {
          when(
            mockCacheHelper.readData(key: AppKeys.userIdKey),
          ).thenAnswer((_) async => null);

          final result = await dataSource.setDefaultAddress(tAddressModel);

          expect(result, isA<ErrorBaseResponse<void>>());
        },
      );

      test(
        'should return ErrorBaseResponse when Firestore set operation fails',
        () async {
          when(
            mockCacheHelper.readData(key: AppKeys.userIdKey),
          ).thenAnswer((_) async => 'user123');
          when(mockNestedDoc.set(any)).thenThrow(
            FirebaseException(
              plugin: 'firestore',
              message: 'Permission denied',
            ),
          );

          final result = await dataSource.setDefaultAddress(tAddressModel);

          expect(result, isA<ErrorBaseResponse<void>>());
          // Since ErrorHandler currently returns unknownError for non-Dio exceptions
          expect((result as ErrorBaseResponse).errorMessage, isNotNull);
        },
      );

      test(
        'should return SuccessBaseResponse with data when getDefaultAddress finds a document',
        () async {
          when(
            mockCacheHelper.readData(key: AppKeys.userIdKey),
          ).thenAnswer((_) async => 'user123');
          when(mockNestedDoc.get(any)).thenAnswer((_) async => mockSnapshot);
          when(mockSnapshot.exists).thenReturn(true);
          when(mockSnapshot.data()).thenReturn(tAddressJson);

          final result = await dataSource.getDefaultAddress();

          expect(result, isA<SuccessBaseResponse<AddressModel?>>());
          expect((result as SuccessBaseResponse).data, tAddressModel);
        },
      );

      test(
        'should return SuccessBaseResponse with null when default address doc does not exist',
        () async {
          when(
            mockCacheHelper.readData(key: AppKeys.userIdKey),
          ).thenAnswer((_) async => 'user123');
          when(mockNestedDoc.get(any)).thenAnswer((_) async => mockSnapshot);
          when(mockSnapshot.exists).thenReturn(false);

          final result = await dataSource.getDefaultAddress();

          expect(result, isA<SuccessBaseResponse<AddressModel?>>());
          expect((result as SuccessBaseResponse).data, isNull);
        },
      );
    });
  });
}
