import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/app_end_points.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';

@module
abstract class DioModule {
  // تعريف مخزن الكاش في الذاكرة
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

    // إعدادات الكاش الافتراضية
    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.noCache, // افتراضياً لا يوجد كاش
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(days: 7),
    );

    // وسيط ذكي يقرأ إعدادات الكاش من الـ Extra المرسلة من الـ ApiClient
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // إذا وجدنا مفتاح 'cache_duration_hours' في الـ Extra، نقوم بتفعيل الكاش
          final cacheHours = options.extra['cache_duration_hours'];
          if (options.method == 'GET' && cacheHours != null) {
            options.extra.addAll(
              cacheOptions
                  .copyWith(
                    policy: CachePolicy.forceCache,
                    maxStale: Nullable(Duration(hours: cacheHours)),
                  )
                  .toExtra(),
            );
          }
          return handler.next(options);
        },
      ),
    );

    // ترتيب الـ Interceptors: الكاش أولاً ثم الأوث ثم اللوجينج
    dio.interceptors.addAll([
      DioCacheInterceptor(options: cacheOptions),
      authInterceptor,
      loggingInterceptor,
    ]);

    return dio;
  }
}
