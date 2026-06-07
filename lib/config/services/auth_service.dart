import '../../core/utils/app_keys.dart';
import '../cache/secure_cache_helper.dart';
import '../di/di.dart';

class AuthService {
  static Future<bool> isLoggedIn() async {
    final secureCacheHelper = getIt<SecureCacheHelper>();
    final token = await secureCacheHelper.readData(key: AppKeys.tokenKey);
    final bool isRemembered =
        await secureCacheHelper.readData(key: AppKeys.rememberMeKey) == 'true';

    return token != null && token.isNotEmpty && isRemembered;
  }
}
