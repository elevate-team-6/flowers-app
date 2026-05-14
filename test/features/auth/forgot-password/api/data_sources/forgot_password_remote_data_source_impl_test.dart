import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/forgot-password/api/api_client/forgot_password_api_client.dart';
import 'package:flowers_app/features/auth/forgot-password/api/data_sources/forgot_password_remote_data_source_impl.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/forgot_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/reset_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/verify_reset_code_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/forgot_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/reset_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/verify_reset_code_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'forgot_password_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ForgotPasswordApiClient])
void main() {
  //Arrange
  late ForgotPasswordRemoteDataSourceImpl forgotPasswordRemoteDataSourceImpl;
  late MockForgotPasswordApiClient mockForgotPasswordApiClient;
  late ForgotPasswordRequest forgotPasswordRequest;
  late VerifyResetCodeRequest verifyResetCodeRequest;
  late ResetPasswordRequest resetPasswordRequest;
  late ForgotPasswordResponse forgotPasswordResponse;
  late VerifyResetCodeResponse verifyResetCodeResponse;
  late ResetPasswordResponse resetPasswordResponse;

  setUpAll(() {
    forgotPasswordRequest = ForgotPasswordRequest(email: 'test@example.com');
    verifyResetCodeRequest = VerifyResetCodeRequest(resetCode: '123456');
    resetPasswordRequest = ResetPasswordRequest(
      email: 'test@example.com',
      newPassword: 'newpass',
    );

    forgotPasswordResponse = ForgotPasswordResponse(
      message: 'OTP sent successfully',
      info: 'Check your email',
      statusMsg: 'success',
    );
    verifyResetCodeResponse = VerifyResetCodeResponse(
      status: 'success',
      message: 'Code verified',
    );
    resetPasswordResponse = ResetPasswordResponse(
      message: 'Password reset successfully',
      token: 'new_token',
    );

    mockForgotPasswordApiClient = MockForgotPasswordApiClient();
    forgotPasswordRemoteDataSourceImpl = ForgotPasswordRemoteDataSourceImpl(
      mockForgotPasswordApiClient,
    );
  });

  group("Forgot Password Remote Data Source Test Group", () {
    group("Success Cases", () {
      test("Test Success Case for forgotPassword", () async {
        //Arrange
        when(
          mockForgotPasswordApiClient.forgotPassword(forgotPasswordRequest),
        ).thenAnswer((_) async => forgotPasswordResponse);

        //ACT
        final result = await forgotPasswordRemoteDataSourceImpl.forgotPassword(
          forgotPasswordRequest,
        );

        //Assert
        expect(result, isA<SuccessBaseResponse<ForgotPasswordResponse>>());
        final successResult =
            result as SuccessBaseResponse<ForgotPasswordResponse>;
        expect(successResult.data, forgotPasswordResponse);

        verify(
          mockForgotPasswordApiClient.forgotPassword(forgotPasswordRequest),
        ).called(1);
      });

      test("Test Success Case for verifyResetCode", () async {
        //Arrange
        when(
          mockForgotPasswordApiClient.verifyResetCode(verifyResetCodeRequest),
        ).thenAnswer((_) async => verifyResetCodeResponse);

        //ACT
        final result = await forgotPasswordRemoteDataSourceImpl.verifyResetCode(
          verifyResetCodeRequest,
        );

        //Assert
        expect(result, isA<SuccessBaseResponse<VerifyResetCodeResponse>>());
        final successResult =
            result as SuccessBaseResponse<VerifyResetCodeResponse>;
        expect(successResult.data, verifyResetCodeResponse);

        verify(
          mockForgotPasswordApiClient.verifyResetCode(verifyResetCodeRequest),
        ).called(1);
      });

      test("Test Success Case for resetPassword", () async {
        //Arrange
        when(
          mockForgotPasswordApiClient.resetPassword(resetPasswordRequest),
        ).thenAnswer((_) async => resetPasswordResponse);

        //ACT
        final result = await forgotPasswordRemoteDataSourceImpl.resetPassword(
          resetPasswordRequest,
        );

        //Assert
        expect(result, isA<SuccessBaseResponse<ResetPasswordResponse>>());
        final successResult =
            result as SuccessBaseResponse<ResetPasswordResponse>;
        expect(successResult.data, resetPasswordResponse);

        verify(
          mockForgotPasswordApiClient.resetPassword(resetPasswordRequest),
        ).called(1);
      });
    });

    group("Failure Cases", () {
      test("Test Error Case for forgotPassword", () async {
        //Arrange
        when(
          mockForgotPasswordApiClient.forgotPassword(forgotPasswordRequest),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        //ACT
        final result = await forgotPasswordRemoteDataSourceImpl.forgotPassword(
          forgotPasswordRequest,
        );

        //Assert
        expect(result, isA<ErrorBaseResponse<ForgotPasswordResponse>>());
        final errorResult = result as ErrorBaseResponse<ForgotPasswordResponse>;
        expect(errorResult.errorMessage, isNotEmpty);

        verify(
          mockForgotPasswordApiClient.forgotPassword(forgotPasswordRequest),
        ).called(1);
      });

      test("Test Error Case for verifyResetCode", () async {
        //Arrange
        when(
          mockForgotPasswordApiClient.verifyResetCode(verifyResetCodeRequest),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
              data: {'message': 'Invalid code'},
            ),
          ),
        );

        //ACT
        final result = await forgotPasswordRemoteDataSourceImpl.verifyResetCode(
          verifyResetCodeRequest,
        );

        //Assert
        expect(result, isA<ErrorBaseResponse<VerifyResetCodeResponse>>());
        final errorResult =
            result as ErrorBaseResponse<VerifyResetCodeResponse>;
        expect(errorResult.errorMessage, isNotEmpty);

        verify(
          mockForgotPasswordApiClient.verifyResetCode(verifyResetCodeRequest),
        ).called(1);
      });

      test("Test Error Case for resetPassword", () async {
        //Arrange
        when(
          mockForgotPasswordApiClient.resetPassword(resetPasswordRequest),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.unknown,
          ),
        );

        //ACT
        final result = await forgotPasswordRemoteDataSourceImpl.resetPassword(
          resetPasswordRequest,
        );

        //Assert
        expect(result, isA<ErrorBaseResponse<ResetPasswordResponse>>());
        final errorResult = result as ErrorBaseResponse<ResetPasswordResponse>;
        expect(errorResult.errorMessage, isNotEmpty);

        verify(
          mockForgotPasswordApiClient.resetPassword(resetPasswordRequest),
        ).called(1);
      });
    });
  });
}
