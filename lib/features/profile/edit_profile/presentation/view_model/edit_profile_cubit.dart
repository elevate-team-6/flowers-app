import 'dart:io';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/config/helpers/phone_extension.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_event.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_state.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  final EditProfileUseCase _editProfileUseCase;
  final UploadProfileUseCase _uploadProfileUseCase;

  EditProfileCubit(this._editProfileUseCase, this._uploadProfileUseCase)
    : super(const EditProfileState());

  late UserProfileEntity currentUser;
  void initialize(UserProfileEntity user) {
    currentUser = user;

    emit(state.copyWith(user: user));
  }

  Future<void> doEvent(EditProfileEvent event) async {
    switch (event) {
      case UpdateProfileEvent():
        await _updateProfile(event.request);

      case UploadPhotoEvent():
        await _uploadPhoto(event.file);
    }
  }

  Future<void> _updateProfile(EditProfileRequest request) async {
    emit(
      state.copyWith(
        editProfileState: state.editProfileState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    final response = await _editProfileUseCase.call(request);

    switch (response) {
      case SuccessBaseResponse<UserEditProfileEntity>():
        currentUser = UserProfileEntity(
          id: currentUser.id,
          firstName: response.data.firstName,
          lastName: response.data.lastName,
          email: currentUser.email,
          phone: response.data.phone,
          gender: currentUser.gender,
          photo: response.data.photo ?? currentUser.photo,
          wishlist: currentUser.wishlist,
          addresses: currentUser.addresses,
        );

        emit(
          state.copyWith(
            user: currentUser,
            isDataChanged: false,
            clearSelectedImage: true,
            uploadPhotoState: const BaseState(),
            editProfileState: BaseState(data: response.data),
          ),
        );

      case ErrorBaseResponse<UserEditProfileEntity>():
        emit(
          state.copyWith(
            editProfileState: state.editProfileState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _uploadPhoto(File file) async {
    emit(
      state.copyWith(
        uploadPhotoState: state.uploadPhotoState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    final response = await _uploadProfileUseCase.call(file);

    switch (response) {
      case SuccessBaseResponse<String>():
        currentUser = UserProfileEntity(
          id: currentUser.id,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          email: currentUser.email,
          phone: currentUser.phone,
          gender: currentUser.gender,
          photo: response.data,
          wishlist: currentUser.wishlist,
          addresses: currentUser.addresses,
        );

        emit(
          state.copyWith(
            user: currentUser,
            uploadPhotoState: BaseState(data: response.data),
          ),
        );

      case ErrorBaseResponse<String>():
        emit(
          state.copyWith(
            uploadPhotoState: state.uploadPhotoState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  void changeImage(File image) {
    emit(state.copyWith(selectedImage: image, isDataChanged: true));
  }

  void checkIfDataChanged({
    required String firstName,
    required String lastName,
    required String phone,
  }) {
    final changed =
        firstName.trim() != (currentUser.firstName ?? '') ||
        lastName.trim() != (currentUser.lastName ?? '') ||
        phone.toEgyptianPhone() != (currentUser.phone ?? '') ||
        state.selectedImage != null;

    emit(state.copyWith(isDataChanged: changed));
  }

  void clearUploadPhotoState() {
    emit(state.copyWith(uploadPhotoState: const BaseState()));
  }

  void clearEditProfileState() {
    emit(state.copyWith(editProfileState: const BaseState()));
  }
}
