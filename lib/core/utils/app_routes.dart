import 'package:flowers_app/features/auth/forgot-password/presentation/screens/forgot_password_screen.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/reset_password_screen.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/verify_reset_code_screen.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/cubit/forgot_password_view_model.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A centralized class for managing all application routes and navigation.
///
/// [AppRoutes] ensures that route names and navigation logic are organized in one place.

abstract class AppRoutes {
  /// Global key to access the [NavigatorState] without a BuildContext.
  /// Useful for navigation from business logic (e.g., inside an Interceptor or Service).
  ///
  /// Example: `AppRoutes.navigatorKey.currentState?.pushNamed(AppRoutes.login);`
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // ---------------------------------------------------------------------------
  // TEAM INSTRUCTIONS - HOW TO ADD A NEW ROUTE:
  // ---------------------------------------------------------------------------
  // 1. Define a 'static const String' for the route name below.
  // 2. Add a 'case' for it in the [onGenerateRoute] method.
  // 3. Return a MaterialPageRoute with the target Screen widget.
  // 4. (Optional) Wrap the screen with a BlocProvider if needed.
  // ---------------------------------------------------------------------------

  // Route Names:
  static const String login = 'login';
  static const String register = '/register';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyResetCode = '/VerifyResetCode';
  static const String emailVerification = '/emailVerification';
  static const String resetPassword = '/resetPassword';

  /// Generates the appropriate [MaterialPageRoute] based on the provided [settings].
  static MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case login:
      //   return MaterialPageRoute(builder: (_) => const LoginPage());
      //
      // case register:
      //   return MaterialPageRoute(builder: (_) => const RegisterPage());
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<ForgotPasswordViewModel>(),
            // create: (context) => getIt<ForgotPasswordViewModel>(),
            child: const ForgotPasswordScreen(),
          ),
        );
      case verifyResetCode:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: args["cubit"],
            child: VerifyResetCodeScreen(email: args["email"]),
          ),
        );
      case resetPassword:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: args["cubit"],
            child: ResetPasswordScreen(email: args["email"]),
          ),
        );
      default:
        return _unDefinedRoute(settings.name);
    }
  }

  /// Helper method to return an error page when an undefined route is requested.
  static MaterialPageRoute<dynamic> _unDefinedRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) =>
          Scaffold(body: Center(child: Text('No route defined for $name'))),
    );
  }
}
