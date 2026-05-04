import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';


class SignupState {
  BaseState<UserEntity> signupState =
      BaseState<UserEntity>(isLoading: false);

  SignupState({BaseState<UserEntity>? signupState}) {
    this.signupState = signupState ?? BaseState<UserEntity>(isLoading: false);
  }

  SignupState copyWith({BaseState<UserEntity>? signupStateParam}) {
    return SignupState(signupState: signupStateParam ?? signupState);
  }
}