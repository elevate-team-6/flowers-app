import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers_app/features/address_details/api/data_sources/address_details_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/address_details/api/address_details_api_client.dart';
import 'package:flowers_app/features/address_details/data/models/address_model.dart';
import 'package:flowers_app/features/address_details/data/models/address_response.dart';

import 'address_details_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([
  SecureCacheHelper,
  FirebaseFirestore,
  AddressDetailsApiClient,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>,
])
void main() {
  late MockSecureCacheHelper cacheHelper;
  late MockFirebaseFirestore firestore;
  late MockAddressDetailsApiClient apiClient;

  late MockCollectionReference<Map<String, dynamic>> usersCollection;
  late MockDocumentReference<Map<String, dynamic>> userDoc;
  late MockCollectionReference<Map<String, dynamic>> defaultAddressCollection;
  late MockDocumentReference<Map<String, dynamic>> defaultAddressDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  late AddressDetailsRemoteDataSourceImpl dataSource;

  setUp(() {
    cacheHelper = MockSecureCacheHelper();
    firestore = MockFirebaseFirestore();
    apiClient = MockAddressDetailsApiClient();

    usersCollection = MockCollectionReference<Map<String, dynamic>>();
    userDoc = MockDocumentReference<Map<String, dynamic>>();
    defaultAddressCollection = MockCollectionReference<Map<String, dynamic>>();
    defaultAddressDoc = MockDocumentReference<Map<String, dynamic>>();
    documentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    dataSource = AddressDetailsRemoteDataSourceImpl(
      cacheHelper,
      firestore,
      apiClient,
    );

    when(
      firestore.collection(AppConstants.usersCollection),
    ).thenReturn(usersCollection);

    when(usersCollection.doc(any)).thenReturn(userDoc);

    when(
      userDoc.collection(AppConstants.defaultAddressCollection),
    ).thenReturn(defaultAddressCollection);

    when(
      defaultAddressCollection.doc(AppConstants.defaultAddressDocId),
    ).thenReturn(defaultAddressDoc);
  });

  group('getAddresses', () {
    test('should return SuccessBaseResponse when api succeeds', () async {
      final response = AddressResponse(message: 'success', addresses: []);

      when(apiClient.getAddresses()).thenAnswer((_) async => response);

      final result = await dataSource.getAddresses();

      expect(result, isA<SuccessBaseResponse<AddressResponse>>());

      verify(apiClient.getAddresses()).called(1);
    });

    test('should return ErrorBaseResponse when api throws', () async {
      when(apiClient.getAddresses()).thenThrow(Exception('error'));

      final result = await dataSource.getAddresses();

      expect(result, isA<ErrorBaseResponse>());
    });
  });

  group('getDefaultAddress', () {
    test('should return address when document exists', () async {
      when(
        cacheHelper.readData(key: AppKeys.userIdKey),
      ).thenAnswer((_) async => 'user-id');

      when(defaultAddressDoc.get()).thenAnswer((_) async => documentSnapshot);

      when(documentSnapshot.exists).thenReturn(true);

      when(
        documentSnapshot.data(),
      ).thenReturn({'_id': '1', 'city': 'Cairo', 'area': 'Nasr City'});

      final result = await dataSource.getDefaultAddress();

      expect(result, isA<SuccessBaseResponse<AddressModel?>>());

      verify(defaultAddressDoc.get()).called(1);
    });

    test('should return null when document does not exist', () async {
      when(
        cacheHelper.readData(key: AppKeys.userIdKey),
      ).thenAnswer((_) async => 'user-id');

      when(defaultAddressDoc.get()).thenAnswer((_) async => documentSnapshot);

      when(documentSnapshot.exists).thenReturn(false);

      final result = await dataSource.getDefaultAddress();

      expect(result, isA<SuccessBaseResponse<AddressModel?>>());
    });
  });

  group('setDefaultAddress', () {
    test('should save address to firestore', () async {
      final address = AddressModel(id: '1', city: 'Cairo');

      when(
        cacheHelper.readData(key: AppKeys.userIdKey),
      ).thenAnswer((_) async => 'user-id');

      when(defaultAddressDoc.set(any)).thenAnswer((_) async {});

      await dataSource.setDefaultAddress(address);

      verify(
        defaultAddressDoc.set({
          ...address.toJson(),
          '_id': address.id,
          'selectedByUser': true,
        }),
      ).called(1);
    });

    test('should save address with selectedByUser false', () async {
      final address = AddressModel(id: '1', city: 'Cairo');

      when(
        cacheHelper.readData(key: AppKeys.userIdKey),
      ).thenAnswer((_) async => 'user-id');

      when(defaultAddressDoc.set(any)).thenAnswer((_) async {});

      await dataSource.setDefaultAddress(address, selectedByUser: false);

      verify(
        defaultAddressDoc.set({
          ...address.toJson(),
          '_id': address.id,
          'selectedByUser': false,
        }),
      ).called(1);
    });
  });
}
