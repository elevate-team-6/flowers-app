import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/cache/hive_helper.dart';
import 'config/cache/secure_cache_helper.dart';
import 'config/di/di.dart';
import 'core/utils/app_constants.dart';
import 'core/utils/app_keys.dart';
import 'features/auth/forgot-password/presentation/view_model/cubit/forgot_password_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  configureDependencies();

  // Initialize Hive
  await getIt<HiveHelper>().init();

  final secureCacheHelper = getIt<SecureCacheHelper>();
  final token = await secureCacheHelper.readData(key: AppKeys.tokenKey);
  final bool isRemembered =
      await secureCacheHelper.readData(key: AppKeys.rememberMeKey) == 'true';
  final isLoggedIn = token != null && token.isNotEmpty && isRemembered;
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(AppConstants.englishCode),
        Locale(AppConstants.arabicCode),
      ],
      path: AppConstants.translationsPath,
      fallbackLocale: const Locale('en'),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, this.isLoggedIn = true});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => getIt<ForgotPasswordViewModel>(),
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            title: 'Flowers App',
            theme: AppTheme.mainTheme,
            navigatorKey: AppRoutes.navigatorKey,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            initialRoute: isLoggedIn ? AppRoutes.mainLayout : AppRoutes.login,
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
          ),
        );
      },
    );
  }
}
