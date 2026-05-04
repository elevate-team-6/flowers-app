import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/signup/domain/ues_cases/signup_use_case.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_events.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


@injectable
class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase _signupUseCase;

  SignupCubit(this._signupUseCase) : super(SignupState());

  Future<void> doEvent(SignupEvents event) async {
    switch (event) {
      case SignupEvent():
        await _signup(event.request);
    }
  }

  Future<void> _signup(SignupRequest request) async {
    emit(state.copyWith(
      signupStateParam: BaseState<UserEntity>(isLoading: true),
    ));

    final result = await _signupUseCase(request);

    switch (result) {
      case SuccessBaseResponse<UserEntity>():
        emit(state.copyWith(
          signupStateParam: BaseState<UserEntity>(data: result.data),
        ));
      case ErrorBaseResponse<UserEntity>():
        emit(state.copyWith(
          signupStateParam: BaseState<UserEntity>(
            errorMessage: result.errorMessage,
          ),
        ));
    }
  }
}