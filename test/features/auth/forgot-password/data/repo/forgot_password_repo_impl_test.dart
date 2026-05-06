import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/forgot-password/api/data_sources/forgot_password_remote_data_source_impl.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/forgot_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/reset_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/verify_reset_code_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/repo/forgot_password_repo_impl.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'forgot_password_repo_impl_test.mocks.dart';

@GenerateMocks([ForgotPasswordRemoteDataSourceImpl])
void main() {
  //Arrange
  late ForgotPasswordRepoImpl forgotPasswordRepoImpl;
  late MockForgotPasswordRemoteDataSourceImpl
  mockForgotPasswordRemoteDataSource;
  late String errMsg;
  late ForgotPasswordResponse forgotPasswordResponse;
  late VerifyResetCodeResponse verifyResetCodeResponse;
  late ResetPasswordResponse resetPasswordResponse;

  setUpAll(() {
    errMsg = "Something went wrong. Please try again later.";
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

    provideDummy<BaseResponse<ForgotPasswordResponse>>(
      SuccessBaseResponse<ForgotPasswordResponse>(ForgotPasswordResponse()),
    );
    provideDummy<BaseResponse<VerifyResetCodeResponse>>(
      SuccessBaseResponse<VerifyResetCodeResponse>(VerifyResetCodeResponse()),
    );
    provideDummy<BaseResponse<ResetPasswordResponse>>(
      SuccessBaseResponse<ResetPasswordResponse>(ResetPasswordResponse()),
    );

    mockForgotPasswordRemoteDataSource =
        MockForgotPasswordRemoteDataSourceImpl();
    forgotPasswordRepoImpl = ForgotPasswordRepoImpl(
      mockForgotPasswordRemoteDataSource,
    );
  });

  group("Forgot Password Function Test Group", () {
    group("Success Cases", () {
      test("Test Success Case for forgotPassword", () async {
        //Arrange
        when(mockForgotPasswordRemoteDataSource.forgotPassword(any)).thenAnswer(
          (_) async => SuccessBaseResponse<ForgotPasswordResponse>(
            forgotPasswordResponse,
          ),
        );

        //ACT
        final result = await forgotPasswordRepoImpl.forgotPassword(
          email: 'test@example.com',
        );

        //Assert
        expect(result, isA<SuccessBaseResponse<ForgotPasswordEntity>>());
        final successResult =
            result as SuccessBaseResponse<ForgotPasswordEntity>;
        expect(successResult.data.message, forgotPasswordResponse.message);
        expect(successResult.data.info, forgotPasswordResponse.info);
        expect(successResult.data.statusMsg, forgotPasswordResponse.statusMsg);

        verify(
          mockForgotPasswordRemoteDataSource.forgotPassword(any),
        ).called(1);
      });
    });

    group("Failure Cases", () {
      test("Test Error Case for forgotPassword", () async {
        //Arrange
        when(mockForgotPasswordRemoteDataSource.forgotPassword(any)).thenAnswer(
          (_) async => ErrorBaseResponse<ForgotPasswordResponse>(errMsg),
        );

        //ACT
        final result = await forgotPasswordRepoImpl.forgotPassword(
          email: 'test@example.com',
        );

        //Assert
        expect(result, isA<ErrorBaseResponse<ForgotPasswordEntity>>());
        final errorResult = result as ErrorBaseResponse<ForgotPasswordEntity>;
        expect(errorResult.errorMessage, errMsg);

        verify(
          mockForgotPasswordRemoteDataSource.forgotPassword(any),
        ).called(1);
      });
    });
  });

  group("Verify Reset Code Function Test Group", () {
    group("Success Cases", () {
      test("Test Success Case for verifyResetCode", () async {
        //Arrange
        when(
          mockForgotPasswordRemoteDataSource.verifyResetCode(any),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<VerifyResetCodeResponse>(
            verifyResetCodeResponse,
          ),
        );

        //ACT
        final result = await forgotPasswordRepoImpl.verifyResetCode(
          resetCode: '123456',
        );

        //Assert
        expect(result, isA<SuccessBaseResponse<ForgotPasswordEntity>>());
        final successResult =
            result as SuccessBaseResponse<ForgotPasswordEntity>;
        expect(successResult.data.status, verifyResetCodeResponse.status);
        expect(successResult.data.message, verifyResetCodeResponse.message);

        verify(
          mockForgotPasswordRemoteDataSource.verifyResetCode(any),
        ).called(1);
      });
    });

    group("Failure Cases", () {
      test("Test Error Case for verifyResetCode", () async {
        //Arrange
        when(
          mockForgotPasswordRemoteDataSource.verifyResetCode(any),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<VerifyResetCodeResponse>(errMsg),
        );

        //ACT
        final result = await forgotPasswordRepoImpl.verifyResetCode(
          resetCode: '123456',
        );

        //Assert
        expect(result, isA<ErrorBaseResponse<ForgotPasswordEntity>>());
        final errorResult = result as ErrorBaseResponse<ForgotPasswordEntity>;
        expect(errorResult.errorMessage, errMsg);

        verify(
          mockForgotPasswordRemoteDataSource.verifyResetCode(any),
        ).called(1);
      });
    });
  });

  group("Reset Password Function Test Group", () {
    group("Success Cases", () {
      test("Test Success Case for resetPassword", () async {
        //Arrange
        when(mockForgotPasswordRemoteDataSource.resetPassword(any)).thenAnswer(
          (_) async =>
              SuccessBaseResponse<ResetPasswordResponse>(resetPasswordResponse),
        );

        //ACT
        final result = await forgotPasswordRepoImpl.resetPassword(
          email: 'test@example.com',
          newPassword: 'newpass',
        );

        //Assert
        expect(result, isA<SuccessBaseResponse<ForgotPasswordEntity>>());
        final successResult =
            result as SuccessBaseResponse<ForgotPasswordEntity>;
        expect(successResult.data.message, resetPasswordResponse.message);
        expect(successResult.data.token, resetPasswordResponse.token);

        verify(mockForgotPasswordRemoteDataSource.resetPassword(any)).called(1);
      });
    });

    group("Failure Cases", () {
      test("Test Error Case for resetPassword", () async {
        //Arrange
        when(mockForgotPasswordRemoteDataSource.resetPassword(any)).thenAnswer(
          (_) async => ErrorBaseResponse<ResetPasswordResponse>(errMsg),
        );

        //ACT
        final result = await forgotPasswordRepoImpl.resetPassword(
          email: 'test@example.com',
          newPassword: 'newpass',
        );

        //Assert
        expect(result, isA<ErrorBaseResponse<ForgotPasswordEntity>>());
        final errorResult = result as ErrorBaseResponse<ForgotPasswordEntity>;
        expect(errorResult.errorMessage, errMsg);

        verify(mockForgotPasswordRemoteDataSource.resetPassword(any)).called(1);
      });
    });
  });
}
