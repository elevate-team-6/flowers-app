import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/forgot_password_screen.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/reset_password_screen.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/screens/verify_reset_code_screen.dart';
import 'package:flowers_app/features/auth/login/presentation/screens/login_screen.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_cubit.dart';
import 'package:flowers_app/features/auth/signup/presentation/screens/signup_screen.dart';
import 'package:flowers_app/features/auth/signup/presentation/screens/terms_and_conditions_screen.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_cubit.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flowers_app/features/home/presentation/view_model/cubit/home_view_model.dart';
import 'package:flowers_app/features/home/presentation/view_model/events/home_events.dart';
import 'package:flowers_app/features/occasions/presentation/screens/occasions_screen.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_cubit.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_event.dart';
import 'package:flowers_app/features/product_details/presentation/screens/product_details_screen.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/screens/edit_profile_screen.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/screens/change_password_screen.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_cubit.dart';
import 'package:flowers_app/features/search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/best_seller/presentation/cubit/best_seller_cubit.dart';
import '../../features/best_seller/presentation/cubit/best_seller_event.dart';
import '../../features/best_seller/presentation/screens/best_seller_screen.dart';
import '../../features/main_layout/presentation/pages/main_layout_screen.dart';
import '../../features/profile/main_profile/domain/entities/user_profile_entity.dart';
import '../../features/search/presentation/view_model/search_bloc.dart';

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
  static const String changePassword = '/changePassword';
  static const String mainLayout = '/mainLayout';
  static const String occasions = '/occasions';
  static const String bestSeller = '/bestSeller';
  static const String productDetails = '/productDetails';
  static const String ordersScreen = '/ordersScreen';
  static const String savedAddressScreen = '/savedAddressScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String aboutUsScreen = '/aboutUsScreen';
  static const String editProfile = '/editProfile';
  static const String search = '/search';

  static MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainLayout:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<HomeViewModel>()..doEvent(GetAllHomeData()),
              ),
              BlocProvider.value(
                value: getIt<CartBloc>()..add(const GetCartEvent()),
              ),
            ],
            child: const MainLayoutScreen(),
          ),
        );

      case occasions:
        final String? occasionId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<OccasionsCubit>()),
              BlocProvider.value(value: getIt<CartBloc>()),
            ],
            child: OccasionsScreen(initialOccasionId: occasionId),
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
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

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

      case changePassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChangePasswordCubit>(),
            child: const ChangePasswordScreen(),
          ),
        );
      case bestSeller:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<BestSellerCubit>()
                      ..doEvent(GetBestSellerProductsEvent()),
              ),
              BlocProvider.value(value: getIt<CartBloc>()),
            ],
            child: const BestSellerScreen(),
          ),
        );

      case productDetails:
        final String productId = settings.arguments.toString();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<ProductDetailsCubit>()
                      ..doEvent(GetProductDetailsEvent(productId)),
              ),
              BlocProvider.value(value: getIt<CartBloc>()),
            ],
            child: const ProductDetailsScreen(),
          ),
        );
      case editProfile:
        final user = settings.arguments as UserProfileEntity;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<EditProfileCubit>(),
            child: EditProfileScreen(profileUser: user),
          ),
        );

      case search:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<SearchBloc>()),
              BlocProvider.value(value: getIt<CartBloc>()),
            ],
            child: const SearchPage(),
          ),
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
