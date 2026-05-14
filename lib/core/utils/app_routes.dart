import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/forgot_password_screen.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/reset_password_screen.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/verify_reset_code_screen.dart';
import 'package:flowers_app/features/auth/login/presentation/screens/login_screen.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_cubit.dart';
import 'package:flowers_app/features/auth/signup/presentation/screens/signup_screen.dart';
import 'package:flowers_app/features/auth/signup/presentation/screens/terms_and_conditions_screen.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_cubit.dart';
import 'package:flowers_app/features/main_layout/presentation/pages/main_layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String login = 'login';
  static const String signup = '/signup';
  static const String termsAndConditions = '/termsAndConditions';
  static const String emailVerification = '/emailVerification';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyResetCode = '/VerifyResetCode';
  static const String resetPassword = '/resetPassword';
  static const String mainLayout = 'mainLayout';
  static const String productDetails = 'productDetails';

  static MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case mainLayout:
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (_) => MainLayoutScreen(
              initialIndex: args?['index'] as int?,
              categoryId: args?['categoryId'] as String?,
            ),
          );

        case login:
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<LoginCubit>(),
              child: const LoginScreen(),
            ),
          );

        case signup:
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<SignupCubit>(),
              child: const SignupScreen(),
            ),
          );

        case termsAndConditions:
          return MaterialPageRoute(
            builder: (_) => const TermsAndConditionsScreen(),
          );

        case forgotPassword:
          return MaterialPageRoute(
            builder: (_) => const ForgotPasswordScreen(),
          );

        case verifyResetCode:
          final String email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => VerifyResetCodeScreen(email: email),
          );

        case resetPassword:
          final String email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: email),
          );

        case productDetails:
          // Handled by Product Details Feature developer
          return _unDefinedRoute(settings.name);

        default:
          return _unDefinedRoute(settings.name);
      }
    } catch (e) {
      return _unDefinedRoute(settings.name);
    }
  }

  static MaterialPageRoute<dynamic> _unDefinedRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('No route defined for $name')),
      ),
    );
  }
}
