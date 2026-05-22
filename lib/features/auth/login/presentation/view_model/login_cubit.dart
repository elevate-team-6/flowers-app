import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final SecureCacheHelper _cacheHelper;
  LoginCubit(this._loginUseCase, this._cacheHelper)
    : super(const LoginState()) {
    on<LoginRequestedEvent>(_onLogin);
    on<TogglePasswordVisibilityEvent>(_onTogglePassword);
    on<ToggleRememberMeEvent>(_onToggleRememberMe);
  }

  Future<void> _onLogin(
    LoginRequestedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, user: null));

    final result = await _loginUseCase(
      LoginRequest(email: event.email, password: event.password),
    );

    switch (result) {
      case SuccessBaseResponse<UserEntity>():
        final user = result.data;

        await _cacheHelper.writeData(key: AppKeys.tokenKey, value: user.token);

        await _cacheHelper.writeData(
          key: AppKeys.rememberMeKey,
          value: event.isRememberMe.toString(),
        );

        emit(state.copyWith(isLoading: false, user: user));
        break;

      case ErrorBaseResponse<UserEntity>():
        emit(
          state.copyWith(isLoading: false, errorMessage: result.errorMessage),
        );
        break;
    }
  }

  void _onToggleRememberMe(
    ToggleRememberMeEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isRememberMe: event.value));
  }

  void _onTogglePassword(
    TogglePasswordVisibilityEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }
}
