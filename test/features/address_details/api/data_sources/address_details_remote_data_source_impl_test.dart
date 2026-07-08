import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers_app/features/address_details/api/data_sources/address_details_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';

import 'address_details_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late MockFirebaseFirestore firestore;

  late MockCollectionReference<Map<String, dynamic>> usersCollection;
  late MockDocumentReference<Map<String, dynamic>> userDoc;
  late MockCollectionReference<Map<String, dynamic>> defaultAddressCollection;
  late MockDocumentReference<Map<String, dynamic>> defaultAddressDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  late AddressDetailsRemoteDataSourceImpl dataSource;

  const userId = 'user-id';

  setUp(() {
    firestore = MockFirebaseFirestore();

    usersCollection = MockCollectionReference<Map<String, dynamic>>();
    userDoc = MockDocumentReference<Map<String, dynamic>>();
    defaultAddressCollection = MockCollectionReference<Map<String, dynamic>>();
    defaultAddressDoc = MockDocumentReference<Map<String, dynamic>>();
    documentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    dataSource = AddressDetailsRemoteDataSourceImpl(firestore);

    when(
      firestore.collection(AppConstants.usersCollection),
    ).thenReturn(usersCollection);

    when(usersCollection.doc(userId)).thenReturn(userDoc);

    when(
      userDoc.collection(AppConstants.defaultAddressCollection),
    ).thenReturn(defaultAddressCollection);

    when(
      defaultAddressCollection.doc(AppConstants.defaultAddressDocId),
    ).thenReturn(defaultAddressDoc);
  });

  group('getDefaultAddress', () {
    test('should return address when document exists', () async {
      when(defaultAddressDoc.get()).thenAnswer((_) async => documentSnapshot);

      when(documentSnapshot.exists).thenReturn(true);

      when(
        documentSnapshot.data(),
      ).thenReturn({'_id': '1', 'city': 'Cairo', 'area': 'Nasr City'});

      final result = await dataSource.getDefaultAddress(userId);

      expect(result, isA<SuccessBaseResponse<AddressModel?>>());

      verify(defaultAddressDoc.get()).called(1);
    });

    test('should return null when document does not exist', () async {
      when(defaultAddressDoc.get()).thenAnswer((_) async => documentSnapshot);

      when(documentSnapshot.exists).thenReturn(false);

      final result = await dataSource.getDefaultAddress(userId);

      expect(result, isA<SuccessBaseResponse<AddressModel?>>());
    });
  });

  group('setDefaultAddress', () {
    test('should save address to firestore', () async {
      final address = AddressModel(id: '1', city: 'Cairo');

      when(defaultAddressDoc.set(any)).thenAnswer((_) async {});

      await dataSource.setDefaultAddress(userId, address);

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

      when(defaultAddressDoc.set(any)).thenAnswer((_) async {});

      await dataSource.setDefaultAddress(
        userId,
        address,
        selectedByUser: false,
      );

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
