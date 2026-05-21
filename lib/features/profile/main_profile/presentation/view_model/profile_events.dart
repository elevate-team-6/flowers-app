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
