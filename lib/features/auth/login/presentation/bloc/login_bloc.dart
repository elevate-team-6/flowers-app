import 'package:flowers_app/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:flowers_app/features/auth/login/presentation/bloc/login_event.dart';
import 'package:flowers_app/features/auth/login/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginState()) {
    on<LoginClicked>(_onLogin);
    on<TogglePasswordVisibility>(_onTogglePassword);
  }

  Future<void> _onLogin(
    LoginClicked event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      user: null,
    ));

    final result = await _loginUseCase(
      LoginRequest(
        email: event.email,
        password: event.password,
      ),
    );

    switch (result) {
      case SuccessBaseResponse<LoginEntity>():
        emit(state.copyWith(
          isLoading: false,
          user: result.data,
        ));

      case ErrorBaseResponse<LoginEntity>():
        emit(state.copyWith(
          isLoading: false,
          errorMessage: result.errorMessage,
        ));
    }
  }

  void _onTogglePassword(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      isPasswordObscure: !state.isPasswordObscure,
    ));
  }
}