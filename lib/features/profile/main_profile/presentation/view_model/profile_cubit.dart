import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:flowers_app/features/profile/main_profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../../../config/cache/secure_cache_helper.dart';
import '../../../../../config/di/di.dart';
import '../../../../../core/utils/app_keys.dart';
import '../../../../../core/utils/app_strings.dart';
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
      case ChangeLanguageEvent():
        emit(state.copyWith(selectedLanguage: event.language));
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
    emit(state.copyWith(profileDateState: const BaseState(isLoading: true)));
    final result = await _getProfileDataUseCase.call();
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

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: const BaseState(isLoading: true)));
    final result = await _logoutUseCase.logout();
    switch (result) {
      case SuccessBaseResponse<void>():
        await getIt<SecureCacheHelper>().deleteData(key: AppKeys.tokenKey);
        emit(state.copyWith(logoutState: const BaseState(isLoading: false)));
        break;
      case ErrorBaseResponse<void>():
        emit(
          state.copyWith(
            logoutState: BaseState(
              isLoading: false,
              errorMessage: AppStrings.someThingWentWrong.tr(),
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
