import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/app_end_points.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';

@module
abstract class DioModule {
  @lazySingleton
  CacheStore get cacheStore => MemCacheStore();

  @lazySingleton
  Dio dio(
      AuthInterceptor authInterceptor,
      LoggingInterceptor loggingInterceptor,
      CacheStore cacheStore,
      ) {
    final dio = Dio();

    dio.options.baseUrl = AppEndPoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.noCache,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(days: 7),
    );

    /// Dynamic cache per request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final cacheHours = options.extra[AppKeys.cacheDurationHours];

          if (options.method == 'GET' && cacheHours != null) {
            options.extra.addAll(
              cacheOptions
                  .copyWith(
                policy: CachePolicy.forceCache,
                maxStale: Nullable(
                  Duration(hours: cacheHours),
                ),
              )
                  .toExtra(),
            );
          }

          handler.next(options);
        },
      ),
    );

    dio.interceptors.addAll([
      DioCacheInterceptor(options: cacheOptions),
      authInterceptor,
      loggingInterceptor,
    ]);

    return dio;
  }
}