import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/features/auth/signup/presentation/screens/signup_screen.dart';
import 'package:flowers_app/features/auth/signup/presentation/screens/terms_and_conditions_screen.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppRoutes {
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

  static const String login = 'login';
  static const String signup = '/signup';
  static const String termsAndConditions = '/termsAndConditions';
  static const String forgetPassword = '/forgetPassword';
  static const String emailVerification = '/emailVerification';
  static const String resetPassword = '/resetPassword';

  static MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
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
      default:
        return _unDefinedRoute(settings.name);
    }
  }

  static MaterialPageRoute<dynamic> _unDefinedRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) =>
          Scaffold(body: Center(child: Text('No route defined for $name'))),
    );
  }
}
