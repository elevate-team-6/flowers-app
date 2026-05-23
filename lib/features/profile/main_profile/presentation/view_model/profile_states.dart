import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';

import '../../domain/entities/user_profile_entity.dart';

enum SelectedLanguage { english, arabic }

class ProfileStates extends Equatable {
  final BaseState<UserProfileEntity> profileDataState;
  final BaseState<void> logoutState;
  final SelectedLanguage selectedLanguage;
  final bool isNotificationEnabled;

  const ProfileStates({
    this.profileDataState = const BaseState(),
    this.logoutState = const BaseState(),
    this.selectedLanguage = SelectedLanguage.english,
    this.isNotificationEnabled = true,
  });

  ProfileStates copyWith({
    BaseState<UserProfileEntity>? profileDateState,
    BaseState<void>? logoutState,
    SelectedLanguage? selectedLanguage,
    bool? isNotificationEnabled,
  }) {
    return ProfileStates(
      profileDataState: profileDateState ?? this.profileDataState,
      logoutState: logoutState ?? this.logoutState,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
    );
  }

  @override
  List<Object?> get props => [
    profileDataState,
    logoutState,
    selectedLanguage,
    isNotificationEnabled,
  ];
}
