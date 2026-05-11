import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/signup/api/api_client/signup_api_client.dart';
import 'package:flowers_app/features/auth/signup/api/data_sources/signup_remote_data_source_impl.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/data/models/responses/signup_response.dart';
import 'package:flowers_app/features/auth/signup/data/models/responses/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'signup_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([SignupApiClient])
void main() {
  late MockSignupApiClient mockApiClient;
  late SignupRemoteDataSourceImpl dataSource;

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
    mockApiClient = MockSignupApiClient();
    dataSource = SignupRemoteDataSourceImpl(mockApiClient);
  });

  group('SignupRemoteDataSourceImpl', () {
    test('returns SuccessBaseResponse when api call succeeds', () async {
      when(mockApiClient.signup(request)).thenAnswer((_) async => fakeResponse);

      final result = await dataSource.signup(request);

      expect(result, isA<SuccessBaseResponse<SignupResponse>>());
      final success = result as SuccessBaseResponse<SignupResponse>;
      expect(success.data.token, 'fake_token');
      expect(success.data.user?.email, 'test@test.com');
    });

    test(
      'returns ErrorBaseResponse when api call throws DioException',
      () async {
        when(mockApiClient.signup(request)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await dataSource.signup(request);

        expect(result, isA<ErrorBaseResponse<SignupResponse>>());
        final error = result as ErrorBaseResponse<SignupResponse>;
        expect(error.errorMessage, isNotEmpty);
      },
    );

    test(
      'returns ErrorBaseResponse when api call throws generic exception',
      () async {
        when(
          mockApiClient.signup(request),
        ).thenThrow(Exception('unexpected error'));

        final result = await dataSource.signup(request);

        expect(result, isA<ErrorBaseResponse<SignupResponse>>());
        final error = result as ErrorBaseResponse<SignupResponse>;
        expect(error.errorMessage, isNotEmpty);
      },
    );
  });
}
