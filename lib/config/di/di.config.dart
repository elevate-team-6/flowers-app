// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart' as _i695;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/address/api/api_client/address_api_client.dart' as _i218;
import '../../features/address/api/data_sources/address_local_data_source_impl.dart'
    as _i923;
import '../../features/address/api/data_sources/address_remote_data_source_impl.dart'
    as _i760;
import '../../features/address/data/data_sources/address_local_data_source_contract.dart'
    as _i313;
import '../../features/address/data/data_sources/address_remote_data_source_contract.dart'
    as _i919;
import '../../features/address/data/data_sources/location_service.dart' as _i78;
import '../../features/address/data/repos/address_repo_impl.dart' as _i715;
import '../../features/address/data/repos/location_repo_impl.dart' as _i58;
import '../../features/address/domain/repositories/address_repo_contract.dart'
    as _i711;
import '../../features/address/domain/repositories/location_repo_contract.dart'
    as _i604;
import '../../features/address/domain/use_cases/add_address_use_case.dart'
    as _i458;
import '../../features/address/domain/use_cases/delete_address_use_case.dart'
    as _i951;
import '../../features/address/domain/use_cases/get_addresses_use_case.dart'
    as _i594;
import '../../features/address/domain/use_cases/get_cities_use_case.dart'
    as _i573;
import '../../features/address/domain/use_cases/get_current_location_use_case.dart'
    as _i990;
import '../../features/address/domain/use_cases/get_governorates_use_case.dart'
    as _i1070;
import '../../features/address/domain/use_cases/get_placemark_use_case.dart'
    as _i588;
import '../../features/address/domain/use_cases/update_address_use_case.dart'
    as _i130;
import '../../features/address/domain/utils/address_matcher.dart' as _i347;
import '../../features/address/presentation/view_model/address_cubit.dart'
    as _i554;
import '../../features/address_details/api/data_sources/address_details_remote_data_source_impl.dart'
    as _i12;
import '../../features/address_details/data/data_sources/address_details_remote_data_source_contract.dart'
    as _i472;
import '../../features/address_details/data/repos/address_details_repo_impl.dart'
    as _i1063;
import '../../features/address_details/domain/repos/address_details_repo_contrect.dart'
    as _i971;
import '../../features/address_details/domain/use_cases/auto_select_nearest_address_use_case.dart'
    as _i273;
import '../../features/address_details/domain/use_cases/find_nearest_address_use_case.dart'
    as _i472;
import '../../features/address_details/domain/use_cases/get_default_address_use_case.dart'
    as _i778;
import '../../features/address_details/domain/use_cases/initialize_default_address_use_case.dart'
    as _i956;
import '../../features/address_details/domain/use_cases/select_default_address_use_case.dart'
    as _i1023;
import '../../features/address_details/domain/use_cases/set_default_address_use_case.dart'
    as _i33;
import '../../features/address_details/domain/use_cases/validate_delivery_location_use_case.dart'
    as _i238;
import '../../features/address_details/presentation/view_model/address_details_cubit.dart'
    as _i491;
import '../../features/auth/forgot-password/api/api_client/forgot_password_api_client.dart'
    as _i886;
import '../../features/auth/forgot-password/api/data_sources/forgot_password_remote_data_source_impl.dart'
    as _i1033;
import '../../features/auth/forgot-password/data/data_sources/forgot_password_remote_data_source_contract.dart'
    as _i632;
import '../../features/auth/forgot-password/data/repo/forgot_password_repo_impl.dart'
    as _i1;
import '../../features/auth/forgot-password/domain/forgot_password_use_cases/forgot_password_use_case.dart'
    as _i536;
import '../../features/auth/forgot-password/domain/forgot_password_use_cases/reset_password_use_case.dart'
    as _i258;
import '../../features/auth/forgot-password/domain/forgot_password_use_cases/verify_reset_code_use_case.dart'
    as _i884;
import '../../features/auth/forgot-password/domain/repo/forgot_password_repo_contract.dart'
    as _i583;
import '../../features/auth/forgot-password/domain/use_cases/forgot_password_use_case.dart'
    as _i473;
import '../../features/auth/forgot-password/domain/use_cases/reset_password_use_case.dart'
    as _i169;
import '../../features/auth/forgot-password/domain/use_cases/verify_reset_code_use_case.dart'
    as _i303;
import '../../features/auth/forgot-password/presentation/view_model/cubit/forgot_password_view_model.dart'
    as _i63;
import '../../features/auth/login/api/api_client/login_api_client.dart' as _i32;
import '../../features/auth/login/api/data_sources/login_remote_data_source_impl.dart'
    as _i584;
import '../../features/auth/login/data/data_sources/login_remote_data_source_contract.dart'
    as _i183;
import '../../features/auth/login/data/repos/login_repo_impl.dart' as _i568;
import '../../features/auth/login/domain/repositories/login_repo_contract.dart'
    as _i628;
import '../../features/auth/login/domain/use_cases/login_use_case.dart' as _i50;
import '../../features/auth/login/presentation/view_model/login_cubit.dart'
    as _i1000;
import '../../features/auth/signup/api/api_client/signup_api_client.dart'
    as _i557;
import '../../features/auth/signup/api/data_sources/signup_remote_data_source_impl.dart'
    as _i1025;
import '../../features/auth/signup/data/data_sources/signup_remote_data_source_contract.dart'
    as _i279;
import '../../features/auth/signup/data/repositories/signup_repo_impl.dart'
    as _i930;
import '../../features/auth/signup/domain/repositories/signup_repo_contract.dart'
    as _i806;
import '../../features/auth/signup/domain/ues_cases/signup_use_case.dart'
    as _i632;
import '../../features/auth/signup/presentation/view_model/signup_cubit.dart'
    as _i782;
import '../../features/best_seller/api/api_client/best_seller_api_client.dart'
    as _i618;
import '../../features/best_seller/api/data_sources/best_seller_remote_data_source_impl.dart'
    as _i395;
import '../../features/best_seller/data/data_sources/best_seller_remote_data_sources_contract.dart'
    as _i346;
import '../../features/best_seller/data/repos/best_seller_repo_impl.dart'
    as _i12;
import '../../features/best_seller/domain/repos/best_seller_repo_contract.dart'
    as _i641;
import '../../features/best_seller/domain/use_cases/best_seller_use_case.dart'
    as _i776;
import '../../features/best_seller/presentation/cubit/best_seller_cubit.dart'
    as _i1049;
import '../../features/cart/api/api_client/cart_api_client.dart' as _i673;
import '../../features/cart/api/data_sources/cart_remote_data_source_impl.dart'
    as _i866;
import '../../features/cart/data/data_sources/cart_remote_data_source_contract.dart'
    as _i447;
import '../../features/cart/data/repos/cart_repo_impl.dart' as _i806;
import '../../features/cart/domain/repos/cart_repo_contract.dart' as _i933;
import '../../features/cart/domain/use_cases/add_to_cart_use_case.dart'
    as _i252;
import '../../features/cart/domain/use_cases/clear_cart_use_case.dart' as _i493;
import '../../features/cart/domain/use_cases/get_cart_use_case.dart' as _i176;
import '../../features/cart/domain/use_cases/remove_item_use_case.dart'
    as _i419;
import '../../features/cart/domain/use_cases/update_quantity_use_case.dart'
    as _i208;
import '../../features/cart/presentation/view_model/cart_bloc.dart' as _i752;
import '../../features/categories/api/api_client/categories_api_client.dart'
    as _i612;
import '../../features/categories/api/data_sources/categories_remote_data_source_contract.dart'
    as _i639;
import '../../features/categories/data/data_sources/categories_remote_data_source_impl.dart'
    as _i596;
import '../../features/categories/data/repositories/categories_repo_contract.dart'
    as _i167;
import '../../features/categories/domain/repositories/categories_repo_impl.dart'
    as _i1031;
import '../../features/categories/domain/use_cases/get_categories_use_case.dart'
    as _i426;
import '../../features/categories/domain/use_cases/get_products_use_case.dart'
    as _i251;
import '../../features/categories/presentation/view_model/categories_cubit.dart'
    as _i960;
import '../../features/checkout/api/checkout_api_client/checkout_api_client.dart'
    as _i978;
import '../../features/checkout/api/data_sourses/checkout_remote_data_source_impl.dart'
    as _i865;
import '../../features/checkout/data/data_sources/checkout_remote_data_source_contract.dart'
    as _i486;
import '../../features/checkout/data/repos/checkout_repo_impl.dart' as _i605;
import '../../features/checkout/domain/repos/checkout_repo_contract.dart'
    as _i778;
import '../../features/checkout/domain/use_cases/card_checkout_use_case.dart'
    as _i725;
import '../../features/checkout/domain/use_cases/cash_checkout_use_case.dart'
    as _i327;
import '../../features/checkout/domain/use_cases/get_delivery_dayes_use_case.dart'
    as _i587;
import '../../features/checkout/presentation/view_model/checkout_cubit.dart'
    as _i868;
import '../../features/home/presentation/view_model/cubit/home_view_model.dart'
    as _i492;
import '../../features/main_layout/presentation/cubit/main_layout_cubit.dart'
    as _i476;
import '../../features/occasions/api/api_client/occasions_api_client.dart'
    as _i1066;
import '../../features/occasions/api/data_sources/occasions_remote_data_source_impl.dart'
    as _i616;
import '../../features/occasions/data/data_sources/occasions_remote_data_source_contract.dart'
    as _i1031;
import '../../features/occasions/data/repositories/occasions_repo_impl.dart'
    as _i156;
import '../../features/occasions/domain/repositories/occasions_repo_contract.dart'
    as _i674;
import '../../features/occasions/domain/use_cases/get_products_use_case.dart'
    as _i634;
import '../../features/occasions/domain/use_cases/occasions_use_case.dart'
    as _i145;
import '../../features/occasions/presentation/view_model/occasions_cubit.dart'
    as _i847;
import '../../features/orders/api/api_client/orders_api_client.dart' as _i107;
import '../../features/orders/api/data_sources/orders_remote_data_source_impl.dart'
    as _i153;
import '../../features/orders/data/data_sources/orders_remote_data_source_contract.dart'
    as _i27;
import '../../features/orders/data/repos/orders_repo_impl.dart' as _i431;
import '../../features/orders/domain/repos/orders_repo_contract.dart' as _i131;
import '../../features/orders/domain/use_cases/get_active_orders_use_case.dart'
    as _i87;
import '../../features/orders/domain/use_cases/get_completed_orders_use_case.dart'
    as _i651;
import '../../features/orders/domain/use_cases/get_user_orders_use_case.dart'
    as _i749;
import '../../features/orders/presentation/view_model/orders_cubit.dart'
    as _i942;
import '../../features/product_details/api/api_client/product_details_api_client.dart'
    as _i327;
import '../../features/product_details/api/data_sources/product_details_remote_data_source_impl.dart'
    as _i873;
import '../../features/product_details/data/data_sources/product_details_remote_data_source_contract.dart'
    as _i870;
import '../../features/product_details/data/repos/product_details_repo_impl.dart'
    as _i480;
import '../../features/product_details/domain/repos/product_details_repo_contract.dart'
    as _i9;
import '../../features/product_details/domain/use_cases/product_details_use_case.dart'
    as _i504;
import '../../features/product_details/presentation/cubit/product_details_cubit.dart'
    as _i4;
import '../../features/profile/edit_profile/api/api_client/edit_profile_api_client.dart'
    as _i831;
import '../../features/profile/edit_profile/api/data_sources/edit_profile_remote_data_sourct_impl.dart'
    as _i1008;
import '../../features/profile/edit_profile/data/data_sources/edit_profile_remote_data_source_contract.dart'
    as _i88;
import '../../features/profile/edit_profile/data/repos/edit_profile_repo_impl.dart'
    as _i98;
import '../../features/profile/edit_profile/domain/repos/edit_profile_repo_contract.dart'
    as _i28;
import '../../features/profile/edit_profile/domain/use_cases/edit_profile_use_case.dart'
    as _i514;
import '../../features/profile/edit_profile/domain/use_cases/upload_photo_use_case.dart'
    as _i978;
import '../../features/profile/edit_profile/presentation/view_model/edit_profile_cubit.dart'
    as _i266;
import '../../features/profile/main_profile/api/api_client/profile_api_client.dart'
    as _i968;
import '../../features/profile/main_profile/api/data_sources/profile_data_source_impl.dart'
    as _i918;
import '../../features/profile/main_profile/data/data_sources/profile_data_source_contract.dart'
    as _i135;
import '../../features/profile/main_profile/data/repos/profile_repo_impl.dart'
    as _i535;
import '../../features/profile/main_profile/domain/repos/profile_repo_contract.dart'
    as _i836;
import '../../features/profile/main_profile/domain/use_cases/get_profile_data_use_case.dart'
    as _i631;
import '../../features/profile/main_profile/domain/use_cases/logout_use_case.dart'
    as _i725;
import '../../features/profile/main_profile/presentation/view_model/profile_cubit.dart'
    as _i648;
import '../../features/profile/reset_password/api/api_client/change_password_api_client.dart'
    as _i627;
import '../../features/profile/reset_password/api/data_sources/change_password_remote_data_source_impl.dart'
    as _i181;
import '../../features/profile/reset_password/data/data_sources/change_password_remote_data_source_contract.dart'
    as _i932;
import '../../features/profile/reset_password/data/repos/change_password_repo_impl.dart'
    as _i760;
import '../../features/profile/reset_password/domain/repos/change_password_repo_contract.dart'
    as _i289;
import '../../features/profile/reset_password/domain/use_cases/change_password_use_case.dart'
    as _i869;
import '../../features/profile/reset_password/presentation/view_model/change_password_cubit.dart'
    as _i113;
import '../../features/search/api/api_client/search_api_client.dart' as _i724;
import '../../features/search/api/data_sources/search_remote_data_source_impl.dart'
    as _i600;
import '../../features/search/data/data_sources/search_local_data_source.dart'
    as _i151;
import '../../features/search/data/data_sources/search_local_data_source_impl.dart'
    as _i574;
import '../../features/search/data/data_sources/search_remote_data_source.dart'
    as _i765;
import '../../features/search/data/repos/search_repo_impl.dart' as _i946;
import '../../features/search/domain/repos/search_repo.dart' as _i41;
import '../../features/search/domain/use_cases/clear_search_history_use_case.dart'
    as _i520;
import '../../features/search/domain/use_cases/get_search_history_use_case.dart'
    as _i15;
import '../../features/search/domain/use_cases/remove_search_query_use_case.dart'
    as _i482;
import '../../features/search/domain/use_cases/save_search_query_use_case.dart'
    as _i716;
import '../../features/search/domain/use_cases/search_products_use_case.dart'
    as _i1040;
import '../../features/search/presentation/view_model/search_bloc.dart'
    as _i315;
import '../cache/cache_module.dart' as _i549;
import '../cache/hive_helper.dart' as _i996;
import '../cache/secure_cache_helper.dart' as _i518;
import '../dio/dio_module.dart' as _i977;
import '../firebase/firebase_module.dart' as _i1055;
import '../interceptors/auth_interceptor.dart' as _i48;
import '../interceptors/logging_interceptor.dart' as _i707;
import '../services/location_service.dart' as _i669;
import '../services/remote_config_service.dart' as _i858;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final cacheModule = _$CacheModule();
    final dioModule = _$DioModule();
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i707.LoggingInterceptor>(() => _i707.LoggingInterceptor());
    gh.factory<_i472.FindNearestAddressUseCase>(
      () => const _i472.FindNearestAddressUseCase(),
    );
    gh.factory<_i476.MainLayoutCubit>(() => _i476.MainLayoutCubit());
    gh.factory<_i87.GetActiveOrdersUseCase>(
      () => const _i87.GetActiveOrdersUseCase(),
    );
    gh.factory<_i651.GetCompletedOrdersUseCase>(
      () => const _i651.GetCompletedOrdersUseCase(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => cacheModule.secureStorage,
    );
    gh.lazySingleton<_i695.CacheStore>(() => dioModule.cacheStore);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i669.LocationService>(() => _i669.LocationService());
    gh.lazySingleton<_i858.RemoteConfigService>(
      () => _i858.RemoteConfigService(),
    );
    gh.lazySingleton<_i78.LocationService>(() => _i78.LocationService());
    gh.lazySingleton<_i347.AddressMatcher>(() => _i347.AddressMatcher());
    gh.lazySingleton<_i996.HiveHelper>(() => _i996.HiveHelperImpl());
    gh.factory<_i238.ValidateDeliveryLocationUseCase>(
      () => _i238.ValidateDeliveryLocationUseCase(gh<_i669.LocationService>()),
    );
    gh.factory<_i313.AddressLocalDataSourceContract>(
      () => _i923.AddressLocalDataSourceImpl(),
    );
    gh.factory<_i151.SearchLocalDataSource>(
      () => _i574.SearchLocalDataSourceImpl(gh<_i996.HiveHelper>()),
    );
    gh.factory<_i604.LocationRepoContract>(
      () => _i58.LocationRepoImpl(gh<_i78.LocationService>()),
    );
    gh.lazySingleton<_i518.SecureCacheHelper>(
      () => _i518.SecureCacheHelperImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i990.GetCurrentLocationUseCase>(
      () => _i990.GetCurrentLocationUseCase(gh<_i604.LocationRepoContract>()),
    );
    gh.factory<_i588.GetPlacemarkUseCase>(
      () => _i588.GetPlacemarkUseCase(gh<_i604.LocationRepoContract>()),
    );
    gh.factory<_i48.AuthInterceptor>(
      () => _i48.AuthInterceptor(gh<_i518.SecureCacheHelper>()),
    );
    gh.factory<_i472.AddressDetailsRemoteDataSourceContract>(
      () => _i12.AddressDetailsRemoteDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(
        gh<_i48.AuthInterceptor>(),
        gh<_i707.LoggingInterceptor>(),
        gh<_i695.CacheStore>(),
      ),
    );
    gh.factory<_i971.AddressDetailsRepoContrect>(
      () => _i1063.AddressRepoDetailsImpl(
        gh<_i472.AddressDetailsRemoteDataSourceContract>(),
        gh<_i518.SecureCacheHelper>(),
      ),
    );
    gh.factory<_i778.GetDefaultAddressUseCase>(
      () => _i778.GetDefaultAddressUseCase(
        gh<_i971.AddressDetailsRepoContrect>(),
      ),
    );
    gh.factory<_i33.SetDefaultAddressUseCase>(
      () =>
          _i33.SetDefaultAddressUseCase(gh<_i971.AddressDetailsRepoContrect>()),
    );
    gh.lazySingleton<_i218.AddressApiClient>(
      () => _i218.AddressApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i673.CartApiClient>(
      () => _i673.CartApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1066.OccasionsApiClient>(
      () => _i1066.OccasionsApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i107.OrdersApiClient>(
      () => _i107.OrdersApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i627.ChangePasswordApiClient>(
      () => _i627.ChangePasswordApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i886.ForgotPasswordApiClient>(
      () => _i886.ForgotPasswordApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i32.LoginApiClient>(() => _i32.LoginApiClient(gh<_i361.Dio>()));
    gh.factory<_i557.SignupApiClient>(
      () => _i557.SignupApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i618.BestSellerApiClient>(
      () => _i618.BestSellerApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i612.CategoriesApiClient>(
      () => _i612.CategoriesApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i978.CheckoutApiClient>(
      () => _i978.CheckoutApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i327.ProductDetailsApiClient>(
      () => _i327.ProductDetailsApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i831.EditProfileApiClient>(
      () => _i831.EditProfileApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i968.ProfileApiClient>(
      () => _i968.ProfileApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i724.SearchApiClient>(
      () => _i724.SearchApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i447.CartRemoteDataSourceContract>(
      () => _i866.CartRemoteDataSourceImpl(gh<_i673.CartApiClient>()),
    );
    gh.factory<_i486.CheckoutRemoteDataSourceContract>(
      () => _i865.CheckoutRemoteDataSourceImpl(
        gh<_i978.CheckoutApiClient>(),
        gh<_i858.RemoteConfigService>(),
      ),
    );
    gh.factory<_i639.CategoriesRemoteDataSourceContract>(
      () =>
          _i596.CategoriesRemoteDataSourceImpl(gh<_i612.CategoriesApiClient>()),
    );
    gh.factory<_i1023.SelectDefaultAddressUseCase>(
      () => _i1023.SelectDefaultAddressUseCase(
        gh<_i33.SetDefaultAddressUseCase>(),
      ),
    );
    gh.factory<_i88.EditProfileRemoteDataSourceContract>(
      () => _i1008.EditProfileRemoteDataSourctImpl(
        gh<_i831.EditProfileApiClient>(),
      ),
    );
    gh.factory<_i933.CartRepoContract>(
      () => _i806.CartRepoImpl(gh<_i447.CartRemoteDataSourceContract>()),
    );
    gh.factory<_i346.BestSellerRemoteDataSourceContract>(
      () =>
          _i395.BestSellerRemoteDataSourceImpl(gh<_i618.BestSellerApiClient>()),
    );
    gh.factory<_i135.ProfileDataSourceContract>(
      () => _i918.ProfileDataSourceImpl(gh<_i968.ProfileApiClient>()),
    );
    gh.factory<_i1031.OccasionsRemoteDataSourceContract>(
      () =>
          _i616.OccasionsRemoteDataSourceImpl(gh<_i1066.OccasionsApiClient>()),
    );
    gh.factory<_i632.ForgotPasswordRemoteDataSourceContract>(
      () => _i1033.ForgotPasswordRemoteDataSourceImpl(
        gh<_i886.ForgotPasswordApiClient>(),
      ),
    );
    gh.factory<_i167.CategoriesRepoContract>(
      () => _i1031.CategoriesRepoImpl(
        gh<_i639.CategoriesRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i778.CheckoutRepoContract>(
      () =>
          _i605.CheckoutRepoImpl(gh<_i486.CheckoutRemoteDataSourceContract>()),
    );
    gh.factory<_i587.GetDeliveryDaysUseCase>(
      () => _i587.GetDeliveryDaysUseCase(gh<_i778.CheckoutRepoContract>()),
    );
    gh.factory<_i870.ProductDetailsRemoteDataSourceContract>(
      () => _i873.ProductDetailsRemoteDataSourceImpl(
        gh<_i327.ProductDetailsApiClient>(),
      ),
    );
    gh.factory<_i919.AddressRemoteDataSourceContract>(
      () => _i760.AddressRemoteDataSourceImpl(gh<_i218.AddressApiClient>()),
    );
    gh.factory<_i765.SearchRemoteDataSource>(
      () => _i600.SearchRemoteDataSourceImpl(gh<_i724.SearchApiClient>()),
    );
    gh.factory<_i932.ChangePasswordRemoteDataSourceContract>(
      () => _i181.ChangePasswordRemoteDataSourceImpl(
        gh<_i627.ChangePasswordApiClient>(),
      ),
    );
    gh.factory<_i426.GetCategoriesUseCase>(
      () => _i426.GetCategoriesUseCase(gh<_i167.CategoriesRepoContract>()),
    );
    gh.factory<_i251.GetProductsUseCase>(
      () => _i251.GetProductsUseCase(gh<_i167.CategoriesRepoContract>()),
    );
    gh.factory<_i27.OrdersRemoteDataSourceContract>(
      () => _i153.OrdersRemoteDataSourceImpl(gh<_i107.OrdersApiClient>()),
    );
    gh.factory<_i279.SignupRemoteDataSourceContract>(
      () => _i1025.SignupRemoteDataSourceImpl(gh<_i557.SignupApiClient>()),
    );
    gh.factory<_i183.LoginRemoteDataSourceContract>(
      () => _i584.LoginRemoteDataSourceImpl(gh<_i32.LoginApiClient>()),
    );
    gh.factory<_i711.AddressRepoContract>(
      () => _i715.AddressRepoImpl(
        gh<_i919.AddressRemoteDataSourceContract>(),
        gh<_i313.AddressLocalDataSourceContract>(),
      ),
    );
    gh.factory<_i131.OrdersRepoContract>(
      () => _i431.OrdersRepoImpl(gh<_i27.OrdersRemoteDataSourceContract>()),
    );
    gh.factory<_i674.OccasionsRepoContract>(
      () => _i156.OccasionsRepoImpl(
        gh<_i1031.OccasionsRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i641.BestSellerRepoContract>(
      () => _i12.BestSellerRepoImpl(
        gh<_i346.BestSellerRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i836.ProfileRepoContract>(
      () => _i535.ProfileRepoImpl(
        gh<_i135.ProfileDataSourceContract>(),
        gh<_i518.SecureCacheHelper>(),
      ),
    );
    gh.factory<_i252.AddToCartUseCase>(
      () => _i252.AddToCartUseCase(gh<_i933.CartRepoContract>()),
    );
    gh.factory<_i493.ClearCartUseCase>(
      () => _i493.ClearCartUseCase(gh<_i933.CartRepoContract>()),
    );
    gh.factory<_i176.GetCartUseCase>(
      () => _i176.GetCartUseCase(gh<_i933.CartRepoContract>()),
    );
    gh.factory<_i419.RemoveItemUseCase>(
      () => _i419.RemoveItemUseCase(gh<_i933.CartRepoContract>()),
    );
    gh.factory<_i208.UpdateQuantityUseCase>(
      () => _i208.UpdateQuantityUseCase(gh<_i933.CartRepoContract>()),
    );
    gh.factory<_i725.CardCheckoutUseCase>(
      () => _i725.CardCheckoutUseCase(gh<_i778.CheckoutRepoContract>()),
    );
    gh.factory<_i327.CashCheckoutUseCase>(
      () => _i327.CashCheckoutUseCase(gh<_i778.CheckoutRepoContract>()),
    );
    gh.factory<_i28.EditProfileRepoContract>(
      () => _i98.EditProfileRepoImpl(
        gh<_i88.EditProfileRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i9.ProductDetailsRepoContract>(
      () => _i480.ProductDetailsRepoImpl(
        gh<_i870.ProductDetailsRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i504.ProductDetailsUseCase>(
      () => _i504.ProductDetailsUseCase(gh<_i9.ProductDetailsRepoContract>()),
    );
    gh.factory<_i289.ChangePasswordRepoContract>(
      () => _i760.ChangePasswordRepoImpl(
        gh<_i932.ChangePasswordRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i634.GetProductsUseCase>(
      () => _i634.GetProductsUseCase(gh<_i674.OccasionsRepoContract>()),
    );
    gh.factory<_i145.OccasionsUseCase>(
      () => _i145.OccasionsUseCase(gh<_i674.OccasionsRepoContract>()),
    );
    gh.factory<_i583.ForgotPasswordRepoContract>(
      () => _i1.ForgotPasswordRepoImpl(
        gh<_i632.ForgotPasswordRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i458.AddAddressUseCase>(
      () => _i458.AddAddressUseCase(gh<_i711.AddressRepoContract>()),
    );
    gh.factory<_i951.DeleteAddressUseCase>(
      () => _i951.DeleteAddressUseCase(gh<_i711.AddressRepoContract>()),
    );
    gh.factory<_i594.GetAddressesUseCase>(
      () => _i594.GetAddressesUseCase(gh<_i711.AddressRepoContract>()),
    );
    gh.factory<_i573.GetCitiesUseCase>(
      () => _i573.GetCitiesUseCase(gh<_i711.AddressRepoContract>()),
    );
    gh.factory<_i1070.GetGovernoratesUseCase>(
      () => _i1070.GetGovernoratesUseCase(gh<_i711.AddressRepoContract>()),
    );
    gh.factory<_i130.UpdateAddressUseCase>(
      () => _i130.UpdateAddressUseCase(gh<_i711.AddressRepoContract>()),
    );
    gh.factory<_i628.LoginRepoContract>(
      () => _i568.LoginRepoImpl(gh<_i183.LoginRemoteDataSourceContract>()),
    );
    gh.factory<_i41.SearchRepo>(
      () => _i946.SearchRepoImpl(
        gh<_i765.SearchRemoteDataSource>(),
        gh<_i151.SearchLocalDataSource>(),
      ),
    );
    gh.factory<_i960.CategoriesCubit>(
      () => _i960.CategoriesCubit(
        gh<_i426.GetCategoriesUseCase>(),
        gh<_i251.GetProductsUseCase>(),
      ),
    );
    gh.factory<_i50.LoginUseCase>(
      () => _i50.LoginUseCase(gh<_i628.LoginRepoContract>()),
    );
    gh.lazySingleton<_i752.CartBloc>(
      () => _i752.CartBloc(
        gh<_i176.GetCartUseCase>(),
        gh<_i252.AddToCartUseCase>(),
        gh<_i208.UpdateQuantityUseCase>(),
        gh<_i419.RemoveItemUseCase>(),
        gh<_i493.ClearCartUseCase>(),
      ),
    );
    gh.factory<_i554.AddressCubit>(
      () => _i554.AddressCubit(
        gh<_i594.GetAddressesUseCase>(),
        gh<_i458.AddAddressUseCase>(),
        gh<_i130.UpdateAddressUseCase>(),
        gh<_i951.DeleteAddressUseCase>(),
        gh<_i1070.GetGovernoratesUseCase>(),
        gh<_i573.GetCitiesUseCase>(),
        gh<_i588.GetPlacemarkUseCase>(),
        gh<_i990.GetCurrentLocationUseCase>(),
        gh<_i347.AddressMatcher>(),
      ),
    );
    gh.factory<_i1000.LoginCubit>(
      () => _i1000.LoginCubit(
        gh<_i50.LoginUseCase>(),
        gh<_i518.SecureCacheHelper>(),
      ),
    );
    gh.factory<_i536.ForgotPasswordUseCase>(
      () => _i536.ForgotPasswordUseCase(gh<_i583.ForgotPasswordRepoContract>()),
    );
    gh.factory<_i258.ResetPasswordUseCase>(
      () => _i258.ResetPasswordUseCase(gh<_i583.ForgotPasswordRepoContract>()),
    );
    gh.factory<_i884.VerifyResetCodeUseCase>(
      () =>
          _i884.VerifyResetCodeUseCase(gh<_i583.ForgotPasswordRepoContract>()),
    );
    gh.factory<_i473.ForgotPasswordUseCase>(
      () => _i473.ForgotPasswordUseCase(gh<_i583.ForgotPasswordRepoContract>()),
    );
    gh.factory<_i169.ResetPasswordUseCase>(
      () => _i169.ResetPasswordUseCase(gh<_i583.ForgotPasswordRepoContract>()),
    );
    gh.factory<_i303.VerifyResetCodeUseCase>(
      () =>
          _i303.VerifyResetCodeUseCase(gh<_i583.ForgotPasswordRepoContract>()),
    );
    gh.factory<_i806.SignupRepoContract>(
      () => _i930.SignupRepoImpl(gh<_i279.SignupRemoteDataSourceContract>()),
    );
    gh.factory<_i632.SignupUseCase>(
      () => _i632.SignupUseCase(gh<_i806.SignupRepoContract>()),
    );
    gh.factory<_i749.GetUserOrdersUseCase>(
      () => _i749.GetUserOrdersUseCase(gh<_i131.OrdersRepoContract>()),
    );
    gh.factory<_i63.ForgotPasswordViewModel>(
      () => _i63.ForgotPasswordViewModel(
        gh<_i536.ForgotPasswordUseCase>(),
        gh<_i884.VerifyResetCodeUseCase>(),
        gh<_i258.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i776.BestSellerUseCase>(
      () => _i776.BestSellerUseCase(gh<_i641.BestSellerRepoContract>()),
    );
    gh.factory<_i273.AutoSelectNearestAddressUseCase>(
      () => _i273.AutoSelectNearestAddressUseCase(
        gh<_i594.GetAddressesUseCase>(),
        gh<_i472.FindNearestAddressUseCase>(),
        gh<_i33.SetDefaultAddressUseCase>(),
        gh<_i669.LocationService>(),
      ),
    );
    gh.factory<_i847.OccasionsCubit>(
      () => _i847.OccasionsCubit(
        gh<_i145.OccasionsUseCase>(),
        gh<_i634.GetProductsUseCase>(),
      ),
    );
    gh.factory<_i631.GetProfileDataUseCase>(
      () => _i631.GetProfileDataUseCase(gh<_i836.ProfileRepoContract>()),
    );
    gh.factory<_i725.LogoutUseCase>(
      () => _i725.LogoutUseCase(gh<_i836.ProfileRepoContract>()),
    );
    gh.factory<_i868.CheckoutCubit>(
      () => _i868.CheckoutCubit(
        gh<_i725.CardCheckoutUseCase>(),
        gh<_i327.CashCheckoutUseCase>(),
        gh<_i587.GetDeliveryDaysUseCase>(),
      ),
    );
    gh.factory<_i514.EditProfileUseCase>(
      () => _i514.EditProfileUseCase(gh<_i28.EditProfileRepoContract>()),
    );
    gh.factory<_i978.UploadProfileUseCase>(
      () => _i978.UploadProfileUseCase(gh<_i28.EditProfileRepoContract>()),
    );
    gh.factory<_i4.ProductDetailsCubit>(
      () => _i4.ProductDetailsCubit(gh<_i504.ProductDetailsUseCase>()),
    );
    gh.factory<_i1049.BestSellerCubit>(
      () => _i1049.BestSellerCubit(gh<_i776.BestSellerUseCase>()),
    );
    gh.factory<_i492.HomeViewModel>(
      () => _i492.HomeViewModel(
        gh<_i145.OccasionsUseCase>(),
        gh<_i426.GetCategoriesUseCase>(),
        gh<_i776.BestSellerUseCase>(),
      ),
    );
    gh.factory<_i869.ChangePasswordUseCase>(
      () => _i869.ChangePasswordUseCase(gh<_i289.ChangePasswordRepoContract>()),
    );
    gh.factory<_i266.EditProfileCubit>(
      () => _i266.EditProfileCubit(
        gh<_i514.EditProfileUseCase>(),
        gh<_i978.UploadProfileUseCase>(),
      ),
    );
    gh.factory<_i520.ClearSearchHistoryUseCase>(
      () => _i520.ClearSearchHistoryUseCase(gh<_i41.SearchRepo>()),
    );
    gh.factory<_i15.GetSearchHistoryUseCase>(
      () => _i15.GetSearchHistoryUseCase(gh<_i41.SearchRepo>()),
    );
    gh.factory<_i482.RemoveSearchQueryUseCase>(
      () => _i482.RemoveSearchQueryUseCase(gh<_i41.SearchRepo>()),
    );
    gh.factory<_i716.SaveSearchHistoryUseCase>(
      () => _i716.SaveSearchHistoryUseCase(gh<_i41.SearchRepo>()),
    );
    gh.factory<_i1040.SearchProductsUseCase>(
      () => _i1040.SearchProductsUseCase(gh<_i41.SearchRepo>()),
    );
    gh.factory<_i956.InitializeDefaultAddressUseCase>(
      () => _i956.InitializeDefaultAddressUseCase(
        gh<_i594.GetAddressesUseCase>(),
        gh<_i778.GetDefaultAddressUseCase>(),
        gh<_i33.SetDefaultAddressUseCase>(),
      ),
    );
    gh.factory<_i113.ChangePasswordCubit>(
      () => _i113.ChangePasswordCubit(
        gh<_i869.ChangePasswordUseCase>(),
        gh<_i518.SecureCacheHelper>(),
      ),
    );
    gh.factory<_i782.SignupCubit>(
      () => _i782.SignupCubit(gh<_i632.SignupUseCase>()),
    );
    gh.factory<_i315.SearchBloc>(
      () => _i315.SearchBloc(
        gh<_i1040.SearchProductsUseCase>(),
        gh<_i15.GetSearchHistoryUseCase>(),
        gh<_i716.SaveSearchHistoryUseCase>(),
        gh<_i520.ClearSearchHistoryUseCase>(),
        gh<_i482.RemoveSearchQueryUseCase>(),
      ),
    );
    gh.factory<_i942.OrdersCubit>(
      () => _i942.OrdersCubit(
        gh<_i749.GetUserOrdersUseCase>(),
        gh<_i87.GetActiveOrdersUseCase>(),
        gh<_i651.GetCompletedOrdersUseCase>(),
      ),
    );
    gh.singleton<_i491.AddressDetailsCubit>(
      () => _i491.AddressDetailsCubit(
        gh<_i956.InitializeDefaultAddressUseCase>(),
        gh<_i1023.SelectDefaultAddressUseCase>(),
        gh<_i238.ValidateDeliveryLocationUseCase>(),
      ),
    );
    gh.factory<_i648.ProfileCubit>(
      () => _i648.ProfileCubit(
        gh<_i631.GetProfileDataUseCase>(),
        gh<_i725.LogoutUseCase>(),
      ),
    );
    return this;
  }
}

class _$CacheModule extends _i549.CacheModule {}

class _$DioModule extends _i977.DioModule {}

class _$FirebaseModule extends _i1055.FirebaseModule {}
