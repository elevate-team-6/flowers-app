import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';

class SignupState extends Equatable {
  final BaseState<UserEntity> signupState;

  SignupState({BaseState<UserEntity>? signupState})
    : signupState = signupState ?? BaseState<UserEntity>(isLoading: false);

  SignupState copyWith({BaseState<UserEntity>? signupStateParam}) {
    return SignupState(signupState: signupStateParam ?? signupState);
  }

  @override
  List<Object?> get props => [signupState];
}
