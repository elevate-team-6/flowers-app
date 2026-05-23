import 'package:equatable/equatable.dart';

import 'profile_states.dart';

sealed class ProfileEvents extends Equatable {
  const ProfileEvents();

  @override
  List<Object?> get props => [];
}

class GetProfileDataEvent extends ProfileEvents {
  const GetProfileDataEvent();
}

class ChangeLanguageEvent extends ProfileEvents {
  final SelectedLanguage language;
  const ChangeLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}

class LogoutEvent extends ProfileEvents {
  const LogoutEvent();
  @override
  List<Object?> get props => [];
}

class ToggleNotificationEvent extends ProfileEvents {
  final bool isEnabled;
  const ToggleNotificationEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}
