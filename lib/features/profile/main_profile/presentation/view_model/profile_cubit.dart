import 'package:bloc/bloc.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:flowers_app/features/profile/main_profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../domain/use_cases/logout_use_case.dart';
import 'profile_events.dart';
import 'profile_states.dart';

@injectable
class ProfileCubit extends Cubit<ProfileStates> {
  final GetProfileDataUseCase _getProfileDataUseCase;
  final LogoutUseCase _logoutUseCase;

  ProfileCubit(this._getProfileDataUseCase, this._logoutUseCase)
    : super(const ProfileStates());

  void doEvent(ProfileEvents event) {
    switch (event) {
      case GetProfileDataEvent():
        _getProfileData();
        break;
      case LogoutEvent():
        _logout();
        break;
      case ToggleNotificationEvent():
        _toggleNotification(event.isEnabled);
        break;
    }
  }

  Future<void> _getProfileData() async {
    emit(state.copyWith(profileDataState: const BaseState(isLoading: true)));
    final result = await _getProfileDataUseCase.call();
    switch (result) {
      case SuccessBaseResponse<UserProfileEntity>():
        emit(
          state.copyWith(
            profileDataState: BaseState<UserProfileEntity>(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
        break;
      case ErrorBaseResponse<UserProfileEntity>():
        emit(
          state.copyWith(
            profileDataState: BaseState<UserProfileEntity>(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: const BaseState(isLoading: true)));
    final result = await _logoutUseCase.logout();
    switch (result) {
      case SuccessBaseResponse<void>():
        emit(state.copyWith(logoutState: const BaseState(isLoading: false)));
        break;
      case ErrorBaseResponse<void>():
        emit(
          state.copyWith(
            logoutState: BaseState(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  void _toggleNotification(bool isEnabled) {
    // Update local state first for instant UI feedback
    emit(state.copyWith(isNotificationEnabled: isEnabled));
    // TODO: Add notification API call here in the future
  }
}
