import 'dart:io';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_event.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  final EditProfileUseCase _editProfileUseCase;
  final UploadProfileUseCase _uploadProfileUseCase;
  EditProfileCubit(this._editProfileUseCase, this._uploadProfileUseCase)
    : super(EditProfileState());
  Future<void> doEvent(EditProfileEvent event) async {
    switch (event) {
      case UpdateProfileEvent():
        await _editProfile(event.request);
      case UploadPhotoEvent():
        await _uploadPhoto(event.file);
    }
  }

  Future<void> _editProfile(EditProfileRequest request) async {
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
        emit(
          state.copyWith(
            editProfileState: state.editProfileState.copyWith(
              isLoading: false,
              data: response.data,
            ),
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
        emit(
          state.copyWith(
            uploadPhotoState: state.uploadPhotoState.copyWith(
              isLoading: false,
              data: response.data,
            ),
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
}
