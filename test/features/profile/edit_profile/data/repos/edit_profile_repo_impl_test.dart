import 'dart:io';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/data_sources/edit_profile_remote_data_source_contract.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/user_model.dart';
import 'package:flowers_app/features/profile/edit_profile/data/repos/edit_profile_repo_impl.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_repo_impl_test.mocks.dart';

@GenerateMocks([
  EditProfileRemoteDataSourceContract,
])
void main() {
  late MockEditProfileRemoteDataSourceContract remoteDataSource;
  late EditProfileRepoImpl repo;

  late EditProfileRequest request;
  late EditProfileResponse editProfileResponse;
  late UserEditProfileEntity userEntity;
  late File file;

  setUpAll(() async {
    request = EditProfileRequest(
      firstName: 'Youssef',
      lastName: 'Singer',
      email: 'youssef@gmail.com',
      phone: '01000000000',
    );

    editProfileResponse = EditProfileResponse(
      message: 'Profile Updated Successfully',
      user: UserModel(
        id: '1',
        firstName: 'Youssef',
        lastName: 'Singer',
        email: 'youssef@gmail.com',
        phone: '01000000000',
        gender: 'male',
        photo: 'null',
      ),
    );

    userEntity = const UserEditProfileEntity(
      firstName: 'Youssef',
      lastName: 'Singer',
      gender: 'male',
      phone: '01000000000',
      photo: 'null',
    );

    file = File('test/image.png');

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsBytes([1, 2, 3]);
    }

    provideDummy<BaseResponse<EditProfileResponse>>(
      SuccessBaseResponse<EditProfileResponse>(
        editProfileResponse,
      ),
    );

    provideDummy<BaseResponse<String>>(
       SuccessBaseResponse<String>('success'),
    );
  });

  setUp(() {
    remoteDataSource = MockEditProfileRemoteDataSourceContract();
    repo = EditProfileRepoImpl(remoteDataSource);
  });

  group('EditProfileRepoImpl', () {
    group('editProfile', () {
      test(
        'should return SuccessBaseResponse<UserEditProfileEntity> '
        'when remote datasource succeeds',
        () async {
          // arrange
          when(
            remoteDataSource.editProfile(request),
          ).thenAnswer(
            (_) async => SuccessBaseResponse<EditProfileResponse>(
              editProfileResponse,
            ),
          );

          // act
          final result = await repo.editProfile(request);

          // assert
          expect(
            result,
            isA<SuccessBaseResponse<UserEditProfileEntity>>(),
          );

          final successResult =
              result as SuccessBaseResponse<UserEditProfileEntity>;

          expect(
            successResult.data,
            equals(userEntity),
          );

          verify(
            remoteDataSource.editProfile(request),
          ).called(1);
        },
      );

      test(
        'should return ErrorBaseResponse<UserEditProfileEntity> '
        'when remote datasource fails',
        () async {
          // arrange
          when(
            remoteDataSource.editProfile(request),
          ).thenAnswer(
            (_) async => ErrorBaseResponse<EditProfileResponse>(
              'error',
            ),
          );

          // act
          final result = await repo.editProfile(request);

          // assert
          expect(
            result,
            isA<ErrorBaseResponse<UserEditProfileEntity>>(),
          );

          final errorResult =
              result as ErrorBaseResponse<UserEditProfileEntity>;

          expect(
            errorResult.errorMessage,
            'error',
          );

          verify(
            remoteDataSource.editProfile(request),
          ).called(1);
        },
      );
    });

    group('uploadPhoto', () {
      test(
        'should return SuccessBaseResponse<String> '
        'when upload photo succeeds',
        () async {
          // arrange
          when(
            remoteDataSource.uploadPhoto(file),
          ).thenAnswer(
            (_) async =>  SuccessBaseResponse<String>(
              'success',
            ),
          );

          // act
          final result = await repo.uploadPhoto(file);

          // assert
          expect(
            result,
            isA<SuccessBaseResponse<String>>(),
          );

          final successResult =
              result as SuccessBaseResponse<String>;

          expect(
            successResult.data,
            'success',
          );

          verify(
            remoteDataSource.uploadPhoto(file),
          ).called(1);
        },
      );

      test(
        'should return ErrorBaseResponse<String> '
        'when upload photo fails',
        () async {
          // arrange
          when(
            remoteDataSource.uploadPhoto(file),
          ).thenAnswer(
            (_) async => ErrorBaseResponse<String>(
              'error',
            ),
          );

          // act
          final result = await repo.uploadPhoto(file);

          // assert
          expect(
            result,
            isA<ErrorBaseResponse<String>>(),
          );

          final errorResult =
              result as ErrorBaseResponse<String>;

          expect(
            errorResult.errorMessage,
            'error',
          );

          verify(
            remoteDataSource.uploadPhoto(file),
          ).called(1);
        },
      );
    });
  });
}