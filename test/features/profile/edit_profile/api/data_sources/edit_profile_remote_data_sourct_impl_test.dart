import 'dart:io';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/edit_profile/api/api_client/edit_profile_api_client.dart';
import 'package:flowers_app/features/profile/edit_profile/api/data_sources/edit_profile_remote_data_sourct_impl.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/upload_photo_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_remote_data_sourct_impl_test.mocks.dart';

@GenerateMocks([EditProfileApiClient])
void main() {
  late MockEditProfileApiClient apiClient;
  late EditProfileRemoteDataSourctImpl remoteDataSource;

  late EditProfileRequest request;
  late EditProfileResponse editProfileResponse;
  late UploadPhotoResponse uploadPhotoResponse;
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
        photo: '',
      ),
    );

    uploadPhotoResponse = UploadPhotoResponse(
      message: 'Photo Uploaded Successfully',
    );

    file = File('test/image.png');

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsBytes([1, 2, 3]);
    }
  });

  setUp(() {
    apiClient = MockEditProfileApiClient();

    remoteDataSource = EditProfileRemoteDataSourctImpl(apiClient);
  });

  group('EditProfileRemoteDataSourctImpl', () {
    group('editProfile', () {
      test('should return SuccessBaseResponse<EditProfileResponse> '
          'when api call succeeds', () async {
        // arrange
        when(
          apiClient.editProfile(request),
        ).thenAnswer((_) async => editProfileResponse);

        // act
        final result = await remoteDataSource.editProfile(request);

        // assert
        expect(result, isA<SuccessBaseResponse<EditProfileResponse>>());

        verify(apiClient.editProfile(request)).called(1);
      });

      test('should return ErrorBaseResponse<EditProfileResponse> '
          'when api call throws exception', () async {
        // arrange
        when(apiClient.editProfile(request)).thenThrow(Exception());

        // act
        final result = await remoteDataSource.editProfile(request);

        // assert
        expect(result, isA<ErrorBaseResponse<EditProfileResponse>>());

        verify(apiClient.editProfile(request)).called(1);
      });
    });

    group('uploadPhoto', () {
      test('should return SuccessBaseResponse<String> '
          'when upload photo succeeds', () async {
        // arrange
        when(
          apiClient.uploadPhoto(any),
        ).thenAnswer((_) async => uploadPhotoResponse);

        // act
        final result = await remoteDataSource.uploadPhoto(file);

        // assert
        expect(result, isA<SuccessBaseResponse<String>>());

        verify(apiClient.uploadPhoto(any)).called(1);
      });

      test('should return ErrorBaseResponse<String> '
          'when upload photo fails', () async {
        // arrange
        when(apiClient.uploadPhoto(any)).thenThrow(Exception());

        // act
        final result = await remoteDataSource.uploadPhoto(file);

        // assert
        expect(result, isA<ErrorBaseResponse<String>>());

        verify(apiClient.uploadPhoto(any)).called(1);
      });
    });
  });
}
