import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';

import '../../domain/entities/user_profile_entity.dart';

enum SelectedLanguage { english, arabic }

class ProfileStates extends Equatable {
  final BaseState<UserProfileEntity> profileDataState;
  final BaseState<void> logoutState;
  final SelectedLanguage selectedLanguage;

  const ProfileStates({
    this.profileDataState = const BaseState(),
    this.logoutState = const BaseState(),
    this.selectedLanguage = SelectedLanguage.english,
  });

  ProfileStates copyWith({
    BaseState<UserProfileEntity>? profileDateState,
    BaseState<void>? logoutState,
    SelectedLanguage? selectedLanguage,
  }) {
    return ProfileStates(
      profileDataState: profileDateState ?? this.profileDataState,
      logoutState: logoutState ?? this.logoutState,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [profileDataState, logoutState, selectedLanguage];
}

class LogoutStates extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const LogoutStates(this.isLoading, this.errorMessage);

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
