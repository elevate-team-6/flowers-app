import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@injectable
class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i("REQUEST[${options.method}] => PATH: ${options.path}");
      _logger.d("EXTRA => ${options.extra}");

      // Redact sensitive headers
      final headers = Map<String, dynamic>.from(options.headers);
      if (headers.containsKey('token')) {
        headers['token'] = 'REDACTED';
      }
      _logger.d("Headers: $headers");

      // Redact sensitive data in body
      dynamic data = options.data;
      if (data is Map) {
        data = Map<String, dynamic>.from(data);
        if (data.containsKey('password')) data['password'] = 'REDACTED';
        if (data.containsKey('token')) data['token'] = 'REDACTED';
      }
      _logger.d("Body: $data");
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i(
        "RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}",
      );
      _logger.d("Data: ${response.data}");
      _logger.d("RESPONSE EXTRA => ${response.extra}");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}",
      );
      _logger.e("Message: ${err.message}");
      _logger.e("Response Data: ${err.response?.data}");
    }
    super.onError(err, handler);
  }
}
