import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/app_end_points.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    LoggingInterceptor loggingInterceptor,
  ) {
    final dio = Dio();

    dio.options.baseUrl = AppEndPoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    dio.interceptors.addAll([authInterceptor, loggingInterceptor]);

    return dio;
  }
}
