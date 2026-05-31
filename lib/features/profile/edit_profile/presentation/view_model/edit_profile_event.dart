import 'dart:io';

import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';

sealed class EditProfileEvent {}

class UpdateProfileEvent extends EditProfileEvent {
  final EditProfileRequest request;

  UpdateProfileEvent({required this.request});
}

class UploadPhotoEvent extends EditProfileEvent {
  final File file;
  UploadPhotoEvent({required this.file});
}
