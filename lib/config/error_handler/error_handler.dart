import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_strings.dart';

class ErrorHandler {
  static Future<BaseResponse<T>> executeApiCall<T>(
    Future<T> Function() call,
  ) async {
    try {
      final result = await call();
      return SuccessBaseResponse(result);
    } catch (e) {
      return ErrorBaseResponse(_handle(e));
    }
  }

  static String _handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return AppStrings.connectionTimeout;
        case DioExceptionType.sendTimeout:
          return AppStrings.sendTimeout;
        case DioExceptionType.receiveTimeout:
          return AppStrings.receiveTimeout;
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        case DioExceptionType.cancel:
          return AppStrings.requestCancelled;
        case DioExceptionType.connectionError:
          return AppStrings.noInternetConnection;
        case DioExceptionType.unknown:
          return AppStrings.unexpectedError;
        default:
          return AppStrings.defaultErrorTryAgain;
      }
    } else {
      return AppStrings.unknownError;
    }
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) {
      return AppStrings.unexpectedErrorTryAgain;
    }

    final dynamic data = response.data;
    String? serverMessage;

    if (data is Map<String, dynamic>) {
      serverMessage = data['message'] ?? data['error'];
    }

    if (serverMessage != null) {
      return _mapErrorMessage(serverMessage);
    }

    switch (response.statusCode) {
      case 400:
        return AppStrings.invalidRequest;
      case 401:
        return AppStrings.authFailed;
      case 403:
        return AppStrings.forbidden;
      case 404:
        return AppStrings.notFound;
      case 500:
        return AppStrings.serverError;
      default:
        return AppStrings.defaultError;
    }
  }

  static String _mapErrorMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('user already exists')) {
      return AppStrings.userAlreadyExists;
    }
    if (lowerMessage.contains('gender') &&
        lowerMessage.contains('must be one of')) {
      return AppStrings.invalidGender;
    }
    if (lowerMessage.contains('invalid phone number format')) {
      return AppStrings.invalidPhoneFormat;
    }

    return message;
  }
}
