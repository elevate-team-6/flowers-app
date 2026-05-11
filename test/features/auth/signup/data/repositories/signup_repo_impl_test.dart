import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/signup/data/data_sources/signup_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/data/models/responses/signup_response.dart';
import 'package:flowers_app/features/auth/signup/data/models/responses/user_model.dart';
import 'package:flowers_app/features/auth/signup/data/repositories/signup_repo_impl.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'signup_repo_impl_test.mocks.dart';

@GenerateMocks([SignupRemoteDataSourceContract])
void main() {
  late MockSignupRemoteDataSourceContract mockDataSource;
  late SignupRepoImpl repo;

  final request = SignupRequest(
    firstName: 'ahmed',
    lastName: 'emam',
    email: 'test@test.com',
    password: 'Ahmed@123',
    rePassword: 'Ahmed@123',
    phone: '+201234567890',
    gender: 'male',
  );

  final fakeUser = UserModel(
    id: '1',
    firstName: 'ahmed',
    lastName: 'emam',
    email: 'test@test.com',
    gender: 'male',
    phone: '+201234567890',
    photo: '',
    role: 'user',
    createdAt: '2025-01-01',
  );

  final fakeResponse = SignupResponse(
    message: 'success',
    token: 'fake_token',
    user: fakeUser,
  );

  setUp(() {
    mockDataSource = MockSignupRemoteDataSourceContract();
    repo = SignupRepoImpl(mockDataSource);
    provideDummy<BaseResponse<SignupResponse>>(ErrorBaseResponse('dummy'));
  });

  group('SignupRepoImpl', () {
    test('returns SuccessBaseResponse when data source succeeds', () async {
      when(
        mockDataSource.signup(request),
      ).thenAnswer((_) async => SuccessBaseResponse(fakeResponse));

      final result = await repo.signup(request);

      expect(result, isA<SuccessBaseResponse<UserEntity>>());
      final success = result as SuccessBaseResponse<UserEntity>;
      expect(success.data.email, 'test@test.com');
      expect(success.data.firstName, 'ahmed');
    });

    test('returns ErrorBaseResponse when data source returns error', () async {
      when(
        mockDataSource.signup(request),
      ).thenAnswer((_) async => ErrorBaseResponse('user already exists'));

      final result = await repo.signup(request);

      expect(result, isA<ErrorBaseResponse<UserEntity>>());
      final error = result as ErrorBaseResponse<UserEntity>;
      expect(error.errorMessage, 'user already exists');
    });

    test('returns ErrorBaseResponse when user is null', () async {
      when(mockDataSource.signup(request)).thenAnswer(
        (_) async => SuccessBaseResponse(
          SignupResponse(message: 'success', token: 'fake_token', user: null),
        ),
      );

      final result = await repo.signup(request);

      expect(result, isA<ErrorBaseResponse<UserEntity>>());
      final error = result as ErrorBaseResponse<UserEntity>;
      expect(error.errorMessage, isNotEmpty);
    });
  });
}
