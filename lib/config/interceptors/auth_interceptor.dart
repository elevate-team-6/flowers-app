import 'package:dio/dio.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final SecureCacheHelper cache;

  AuthInterceptor(this.cache);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await cache.readData(key: AppKeys.tokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }


    handler.next(options);
  }
}
