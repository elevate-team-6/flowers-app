import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_event.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_state.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_cubit_test.mocks.dart';

@GenerateMocks([EditProfileUseCase, UploadProfileUseCase])
void main() {
  late MockEditProfileUseCase editProfileUseCase;
  late MockUploadProfileUseCase uploadProfileUseCase;

  late EditProfileCubit cubit;

  late EditProfileRequest request;
  late UserEditProfileEntity userEntity;
  late UserProfileEntity userProfileEntity;
  late File file;

  setUpAll(() async {
    request = EditProfileRequest(
      firstName: 'Youssef',
      lastName: 'Singer',
      email: 'youssef@gmail.com',
      phone: '01000000000',
    );

    userEntity = UserEditProfileEntity(
      firstName: 'Youssef',
      lastName: 'Singer',
      phone: '01000000000',
      gender: 'male',
    );

    userProfileEntity = UserProfileEntity(
      firstName: 'Youssef',
      lastName: 'Singer',
      email: 'youssef@gmail.com',
      phone: '01000000000',
      gender: 'male',
      photo: '',
    );

    file = File('test/image.png');

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsBytes([1, 2, 3]);
    }

    provideDummy<BaseResponse<UserEditProfileEntity>>(
      SuccessBaseResponse(userEntity),
    );

    provideDummy<BaseResponse<String>>(SuccessBaseResponse('success'));
  });

  setUp(() {
    editProfileUseCase = MockEditProfileUseCase();
    uploadProfileUseCase = MockUploadProfileUseCase();

    cubit = EditProfileCubit(editProfileUseCase, uploadProfileUseCase);

    cubit.initialize(userProfileEntity);
  });

  group('EditProfileCubit', () {
    blocTest<EditProfileCubit, EditProfileState>(
      'emit loading then success when edit profile succeeds',
      setUp: () {
        when(
          editProfileUseCase.call(request),
        ).thenAnswer((_) async => SuccessBaseResponse(userEntity));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(UpdateProfileEvent(request: request));
      },
      expect: () => [
        EditProfileState(
          user: userProfileEntity,
          editProfileState: const BaseState(isLoading: true),
        ),
        isA<EditProfileState>()
            .having(
              (state) => state.editProfileState.isLoading,
              'isLoading',
              false,
            )
            .having((state) => state.editProfileState.data, 'data', userEntity)
            .having((state) => state.isDataChanged, 'isDataChanged', false),
      ],
      verify: (_) {
        verify(editProfileUseCase.call(request)).called(1);
      },
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'emit loading then error when edit profile fails',
      setUp: () {
        when(
          editProfileUseCase.call(request),
        ).thenAnswer((_) async => ErrorBaseResponse('error'));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(UpdateProfileEvent(request: request));
      },
      expect: () => [
        EditProfileState(
          user: userProfileEntity,
          editProfileState: const BaseState(isLoading: true),
        ),
        isA<EditProfileState>()
            .having(
              (state) => state.editProfileState.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.editProfileState.errorMessage,
              'errorMessage',
              'error',
            ),
      ],
      verify: (_) {
        verify(editProfileUseCase.call(request)).called(1);
      },
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'emit loading then success when upload photo succeeds',
      setUp: () {
        when(
          uploadProfileUseCase.call(file),
        ).thenAnswer((_) async => SuccessBaseResponse('success'));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(UploadPhotoEvent(file: file));
      },
      expect: () => [
        EditProfileState(
          user: userProfileEntity,
          uploadPhotoState: const BaseState(isLoading: true),
        ),
        isA<EditProfileState>()
            .having(
              (state) => state.uploadPhotoState.isLoading,
              'isLoading',
              false,
            )
            .having((state) => state.uploadPhotoState.data, 'data', 'success'),
      ],
      verify: (_) {
        verify(uploadProfileUseCase.call(file)).called(1);
      },
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'emit loading then error when upload photo fails',
      setUp: () {
        when(
          uploadProfileUseCase.call(file),
        ).thenAnswer((_) async => ErrorBaseResponse('error'));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(UploadPhotoEvent(file: file));
      },
      expect: () => [
        EditProfileState(
          user: userProfileEntity,
          uploadPhotoState: const BaseState(isLoading: true),
        ),
        isA<EditProfileState>()
            .having(
              (state) => state.uploadPhotoState.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.uploadPhotoState.errorMessage,
              'errorMessage',
              'error',
            ),
      ],
      verify: (_) {
        verify(uploadProfileUseCase.call(file)).called(1);
      },
    );
  });
}
