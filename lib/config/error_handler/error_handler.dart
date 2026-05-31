import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorHandler {
  static Future<BaseResponse<T>> handleApiCall<T>(
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
          return AppStrings.connectionTimeout.tr();
        case DioExceptionType.sendTimeout:
          return AppStrings.sendTimeout.tr();
        case DioExceptionType.receiveTimeout:
          return AppStrings.receiveTimeout.tr();
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        case DioExceptionType.cancel:
          return AppStrings.requestCancelled.tr();
        case DioExceptionType.connectionError:
          return AppStrings.noInternetConnection.tr();
        case DioExceptionType.unknown:
          return AppStrings.unexpectedError.tr();
        default:
          return AppStrings.defaultErrorTryAgain.tr();
      }
    } else {
      return AppStrings.unknownError.tr();
    }
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) {
      return AppStrings.unexpectedErrorTryAgain.tr();
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
        return AppStrings.invalidRequest.tr();
      case 401:
        return AppStrings.authFailed.tr();
      case 403:
        return AppStrings.forbidden.tr();
      case 404:
        return AppStrings.notFound.tr();
      case 500:
        return AppStrings.serverError.tr();
      default:
        return AppStrings.defaultError.tr();
    }
  }

  static String _mapErrorMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('user already exists')) {
      return AppStrings.userAlreadyExists.tr();
    }
    if (lowerMessage.contains('gender') &&
        lowerMessage.contains('must be one of')) {
      return AppStrings.invalidGender.tr();
    }
    if (lowerMessage.contains('invalid phone number format')) {
      return AppStrings.invalidPhoneFormat.tr();
    }

    return message;
  }
}
