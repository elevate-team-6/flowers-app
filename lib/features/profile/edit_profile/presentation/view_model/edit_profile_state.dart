import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';

class EditProfileState extends Equatable {
  final BaseState<UserEditProfileEntity> editProfileState;
  final BaseState<String> uploadPhotoState;
  const EditProfileState({
    this.editProfileState = const BaseState(),
    this.uploadPhotoState = const BaseState(),
  });
  EditProfileState copyWith({
    BaseState<UserEditProfileEntity>? editProfileState,
    BaseState<String>? uploadPhotoState,
  }) {
    return EditProfileState(
      editProfileState: editProfileState ?? this.editProfileState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
    );
  }

  @override
  List<Object?> get props => [editProfileState, uploadPhotoState];
}
