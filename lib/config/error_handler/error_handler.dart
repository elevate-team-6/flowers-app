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
      return ErrorBaseResponse(handle(e));
    }
  }

  static String handle(dynamic error) {
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

    final statusCode = response.statusCode;
    final dynamic data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return data['message'];
    }

    switch (statusCode) {
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
}
