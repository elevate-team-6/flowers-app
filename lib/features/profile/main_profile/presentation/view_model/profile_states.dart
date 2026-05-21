import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';

import '../../domain/entities/user_profile_entity.dart';

enum SelectedLanguage { english, arabic }

class ProfileStates extends Equatable {
  final BaseState<UserProfileEntity> profileDateState;
  final SelectedLanguage selectedLanguage;

  const ProfileStates({
    this.profileDateState = const BaseState(),
    this.selectedLanguage = SelectedLanguage.english,
  });

  ProfileStates copyWith({
    BaseState<UserProfileEntity>? profileDateState,
    SelectedLanguage? selectedLanguage,
  }) {
    return ProfileStates(
      profileDateState: profileDateState ?? this.profileDateState,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [profileDateState, selectedLanguage];
}
