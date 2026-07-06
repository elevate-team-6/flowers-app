import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/auth/login/data/data_sources/login_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/login_response.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/user_dto.dart';
import 'package:flowers_app/features/auth/login/data/repos/login_repo_impl.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_repo_impl_test.mocks.dart';

@GenerateMocks([
  LoginRemoteDataSourceContract,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
])
void main() {
  late LoginRepoImpl repo;
  late MockLoginRemoteDataSourceContract mockDataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;

  setUpAll(() {
    provideDummy<BaseResponse<LoginResponse>>(
      SuccessBaseResponse(
        LoginResponse(
          token: 'dummy',
          user: UserDto(
            id: '',
            firstName: '',
            lastName: '',
            email: '',
            gender: '',
            phone: '',
            photo: '',
            role: '',
            createdAt: '',
          ),
        ),
      ),
    );
  });

  setUp(() {
    mockDataSource = MockLoginRemoteDataSourceContract();
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    repo = LoginRepoImpl(mockDataSource, mockFirestore);
  });

  tearDown(() {
    reset(mockDataSource);
    reset(mockFirestore);
  });

  group('LoginRepoImpl Tests', () {
    test(
      'should return LoginEntity and update Firestore when API call is successful',
      () async {
        final request = LoginRequest(
          email: 'test@test.com',
          password: '123456',
        );

        final fakeResponse = LoginResponse(
          token: '123',
          user: UserDto(
            id: '1',
            firstName: 'youssef',
            lastName: 'singer',
            email: 'test@test.com',
            gender: 'male',
            phone: '01000000000',
            photo: 'photo.png',
            role: 'user',
            createdAt: '2026',
          ),
        );

        // Setup Firestore mocks
        when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
        when(
          mockCollectionReference.doc(any),
        ).thenReturn(mockDocumentReference);
        when(mockDocumentReference.set(any, any)).thenAnswer((_) async => {});

        when(
          mockDataSource.login(request),
        ).thenAnswer((_) async => SuccessBaseResponse(fakeResponse));

        final result = await repo.login(request);

        expect(result, isA<SuccessBaseResponse<UserEntity>>());

        final success = result as SuccessBaseResponse<UserEntity>;

        expect(success.data.token, '123');
        expect(success.data.email, 'test@test.com');
        expect(success.data.firstName, 'youssef');
        expect(success.data.id, '1');

        // Verify Firestore update
        verify(
          mockFirestore.collection(AppConstants.usersCollection),
        ).called(1);
        verify(mockCollectionReference.doc(fakeResponse.user!.id)).called(1);

        verify(mockDataSource.login(request)).called(1);
      },
    );

    test('should return ErrorBaseResponse when API fails', () async {
      final request = LoginRequest(email: 'test@test.com', password: '123456');

      when(
        mockDataSource.login(request),
      ).thenAnswer((_) async => ErrorBaseResponse('Server error'));

      final result = await repo.login(request);

      expect(result, isA<ErrorBaseResponse<UserEntity>>());

      final error = result as ErrorBaseResponse<UserEntity>;

      expect(error.errorMessage, 'Server error');

      verify(mockDataSource.login(request)).called(1);
      verifyNoMoreInteractions(mockDataSource);
      verifyZeroInteractions(mockFirestore);
    });
  });
}
