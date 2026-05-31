import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';

import '../../domain/entities/user_profile_entity.dart';

class ProfileStates extends Equatable {
  final BaseState<UserProfileEntity> profileDataState;
  final BaseState<void> logoutState;
  final bool isNotificationEnabled;

  const ProfileStates({
    this.profileDataState = const BaseState(),
    this.logoutState = const BaseState(),
    this.isNotificationEnabled = true,
  });

  ProfileStates copyWith({
    BaseState<UserProfileEntity>? profileDataState,
    BaseState<void>? logoutState,
    bool? isNotificationEnabled,
  }) {
    return ProfileStates(
      profileDataState: profileDataState ?? this.profileDataState,
      logoutState: logoutState ?? this.logoutState,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
    );
  }

  @override
  List<Object?> get props => [
    profileDataState,
    logoutState,
    isNotificationEnabled,
  ];
}
