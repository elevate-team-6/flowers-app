import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';

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
          return "Connection timed out. Please check your internet and try again.";
        case DioExceptionType.sendTimeout:
          return "Request timed out while sending data. Please try again.";
        case DioExceptionType.receiveTimeout:
          return "Server took too long to respond. Please try again.";
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        case DioExceptionType.cancel:
          return "The request was cancelled.";
        case DioExceptionType.connectionError:
          return "No internet connection. Please check your network.";
        case DioExceptionType.unknown:
          return "An unexpected error occurred. Please try again later.";
        default:
          return "Oops! Something went wrong. Please try again.";
      }
    } else {
      return "An unknown error occurred. Please try again.";
    }
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) {
      return "An unexpected error occurred. Please try again.";
    }

    final statusCode = response.statusCode;
    final dynamic data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return data['message'];
    }

    switch (statusCode) {
      case 400:
        return "Invalid request. Please check your input.";
      case 401:
        return "Authentication failed. Please log in again.";
      case 403:
        return "You don't have permission to perform this action.";
      case 404:
        return "The requested resource was not found.";
      case 500:
        return "Our servers are currently experiencing issues. Please try again later.";
      default:
        return "Oops! Something went wrong.";
    }
  }
}
