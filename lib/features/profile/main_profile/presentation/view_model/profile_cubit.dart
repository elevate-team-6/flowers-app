import 'package:bloc/bloc.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:flowers_app/features/profile/main_profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import 'profile_events.dart';
import 'profile_states.dart';

@injectable
class ProfileCubit extends Cubit<ProfileStates> {
  final GetProfileDataUseCase _useCase;

  ProfileCubit(this._useCase) : super(const ProfileStates());

  void doEvent(ProfileEvents event) {
    switch (event) {
      case GetProfileDataEvent():
        _getProfileData();
        break;
      case ChangeLanguageEvent():
        emit(state.copyWith(selectedLanguage: event.language));
        break;
    }
  }

  Future<void> _getProfileData() async {
    emit(state.copyWith(profileDateState: const BaseState(isLoading: true)));
    final result = await _useCase.call();
    switch (result) {
      case SuccessBaseResponse<UserProfileEntity>():
        emit(
          state.copyWith(
            profileDateState: BaseState<UserProfileEntity>(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
        break;
      case ErrorBaseResponse<UserProfileEntity>():
        emit(
          state.copyWith(
            profileDateState: BaseState<UserProfileEntity>(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
