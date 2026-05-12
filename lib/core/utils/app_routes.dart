import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/forgot_password_screen.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/reset_password_screen.dart';
import 'package:flowers_app/features/occasions/presentation/screens/occasions_screen.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/main_layout/presentation/pages/main_layout_screen.dart';
import 'package:flutter/material.dart';

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
  static const String mainLayout = '/mainLayout';
  static const String occasions = '/occasions';

  /// Generates the appropriate [MaterialPageRoute] based on the provided [settings].
  static MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayoutScreen());
      case occasions:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OccasionsCubit>(),
            child: const OccasionsScreen(),
          ),
        );
      // case login:
      //   return MaterialPageRoute(builder: (_) => const LoginPage());
      //
      // case register:
      //   return MaterialPageRoute(builder: (_) => const RegisterPage());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      // case verifyResetCode:
      // final String email = settings.arguments as String;
      // return MaterialPageRoute(
      //   builder: (_) => VerifyResetCodeScreen(email: email),
      // );

      case resetPassword:
        final String email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: email),
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
