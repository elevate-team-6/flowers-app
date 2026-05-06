import 'package:flowers_app/features/auth/login/api/data_sources/login_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/login/api/api_client/login_api_client.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/login_response.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/user.dart';

import 'login_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([LoginApiClient])
void main() {

  setUpAll(() {
    provideDummy<BaseResponse<LoginResponse>>(
      SuccessBaseResponse(
        LoginResponse(
          token: 'dummy',
          user: User(
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

  late LoginRemoteDataSourceImpl dataSource;
  late MockLoginApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockLoginApiClient();
    dataSource = LoginRemoteDataSourceImpl(mockApiClient);
  });

  group('LoginRemoteDataSourceImpl Tests', () {

    test('should return SuccessBaseResponse when API call is successful', () async {

      final request = LoginRequest(
        email: 'test@test.com',
        password: '123456',
      );

      final fakeResponse = LoginResponse(
        token: '123',
        user: User(
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

      when(mockApiClient.login(request))
          .thenAnswer((_) async => fakeResponse);

      final result = await dataSource.login(request);

      expect(result, isA<SuccessBaseResponse<LoginResponse>>());

      final success = result as SuccessBaseResponse<LoginResponse>;

      expect(success.data.token, '123');

      verify(mockApiClient.login(request)).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('should return ErrorBaseResponse when API throws exception', () async {

      final request = LoginRequest(
        email: 'test@test.com',
        password: '123456',
      );

      when(mockApiClient.login(request))
          .thenThrow(Exception('error'));

      final result = await dataSource.login(request);

      expect(result, isA<ErrorBaseResponse<LoginResponse>>());
    });

  });
}