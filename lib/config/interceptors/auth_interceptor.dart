import 'package:dio/dio.dart';
import 'package:flowers_app/config/cache/cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final CacheHelper cache;

  AuthInterceptor(this.cache);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await cache.readData(key: AppKeys.tokenKey);

    if (token != null) {
      options.headers[AppKeys.tokenKey] = token;
    }

    handler.next(options);
  }
}
