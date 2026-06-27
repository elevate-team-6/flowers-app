import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/config/services/firebase_service.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  SecureCacheHelper,
  FirebaseMessaging,
])
void main() {
  late FirebaseService firebaseService;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseMessaging mockMessaging;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocument;
  late MockSecureCacheHelper mockSecureCacheHelper;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockMessaging = MockFirebaseMessaging();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocument = MockDocumentReference<Map<String, dynamic>>();
    mockSecureCacheHelper = MockSecureCacheHelper();

    // Register SecureCacheHelper in GetIt
    if (getIt.isRegistered<SecureCacheHelper>()) {
      getIt.unregister<SecureCacheHelper>();
    }
    getIt.registerSingleton<SecureCacheHelper>(mockSecureCacheHelper);

    firebaseService = FirebaseService(mockFirestore, mockMessaging);
  });

  group('updateUserLanguage', () {
    const tUserId = 'user123';
    const tLanguageCode = 'ar';

    test(
      'should update language in Firestore when userId is not null',
      () async {
        // arrange
        when(
          mockSecureCacheHelper.readData(key: AppKeys.userIdKey),
        ).thenAnswer((_) async => tUserId);

        when(
          mockFirestore.collection(AppConstants.usersCollection),
        ).thenReturn(mockCollection);

        when(mockCollection.doc(tUserId)).thenReturn(mockDocument);

        when(
          mockDocument.update({AppConstants.languageField: tLanguageCode}),
        ).thenAnswer((_) async => Future.value());

        // act
        await firebaseService.updateUserLanguage(tLanguageCode);

        // assert
        verify(mockSecureCacheHelper.readData(key: AppKeys.userIdKey));
        verify(mockFirestore.collection(AppConstants.usersCollection));
        verify(mockCollection.doc(tUserId));
        verify(
          mockDocument.update({AppConstants.languageField: tLanguageCode}),
        );
      },
    );

    test('should not call Firestore when userId is null', () async {
      // arrange
      when(
        mockSecureCacheHelper.readData(key: AppKeys.userIdKey),
      ).thenAnswer((_) async => null);

      // act
      await firebaseService.updateUserLanguage(tLanguageCode);

      // assert
      verify(mockSecureCacheHelper.readData(key: AppKeys.userIdKey));
      verifyZeroInteractions(mockFirestore);
    });

    test(
      'should catch error and not throw when Firestore update fails',
      () async {
        // arrange
        when(
          mockSecureCacheHelper.readData(key: AppKeys.userIdKey),
        ).thenAnswer((_) async => tUserId);

        when(
          mockFirestore.collection(AppConstants.usersCollection),
        ).thenReturn(mockCollection);

        when(mockCollection.doc(tUserId)).thenReturn(mockDocument);

        when(mockDocument.update(any)).thenThrow(Exception('Firestore Error'));

        // act & assert
        await expectLater(
          () => firebaseService.updateUserLanguage(tLanguageCode),
          returnsNormally,
        );

        verify(mockDocument.update(any));
      },
    );
  });
}
