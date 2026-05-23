import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/user_dto.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';

class EditProfileState extends Equatable {
  final BaseState<UserEditProfileEntity> editProfileState;
  final BaseState<String> uploadPhotoState;
  final File? selectedImage;
  final bool isDataChanged;
  final UserDto? user;

  const EditProfileState({
    this.editProfileState = const BaseState(),
    this.uploadPhotoState = const BaseState(),
    this.selectedImage,
    this.isDataChanged = false,
    this.user,
  });

  EditProfileState copyWith({
    BaseState<UserEditProfileEntity>? editProfileState,
    BaseState<String>? uploadPhotoState,
    File? selectedImage,
    bool clearSelectedImage = false,
    bool? isDataChanged,
    UserDto? user,
  }) {
    return EditProfileState(
      editProfileState: editProfileState ?? this.editProfileState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
      selectedImage: clearSelectedImage
          ? null
          : selectedImage ?? this.selectedImage,
      isDataChanged: isDataChanged ?? this.isDataChanged,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    editProfileState,
    uploadPhotoState,
    selectedImage,
    isDataChanged,
    user,
  ];
}
