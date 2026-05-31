import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/profile/main_profile/data/data_sources/profile_data_source_contract.dart';
import 'package:flowers_app/features/profile/main_profile/data/models/response/get_profile_response.dart';
import 'package:flowers_app/features/profile/main_profile/data/models/user_profile_model.dart';
import 'package:flowers_app/features/profile/main_profile/data/repos/profile_repo_impl.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileDataSourceContract, SecureCacheHelper])
void main() {
  late ProfileRepoImpl repository;
  late MockProfileDataSourceContract mockDataSource;
  late MockSecureCacheHelper mockSecureCacheHelper;

  setUpAll(() {
    provideDummy<BaseResponse<GetProfileResponse>>(
      SuccessBaseResponse(const GetProfileResponse()),
    );
    provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(null));
  });

  setUp(() {
    mockDataSource = MockProfileDataSourceContract();
    mockSecureCacheHelper = MockSecureCacheHelper();
    repository = ProfileRepoImpl(mockDataSource, mockSecureCacheHelper);
  });

  group('getProfileData', () {
    const tUserProfileModel = UserProfileModel(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      photo: 'photo_url',
      wishlist: [],
      addresses: [],
    );

    const tUserProfileEntity = UserProfileEntity(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      photo: 'photo_url',
      wishlist: [],
      addresses: [],
    );
    const tProfileResponse = GetProfileResponse(user: tUserProfileModel);

    test('success with user data', () async {
      // Arrange
      when(
        mockDataSource.getProfileData(),
      ).thenAnswer((_) async => SuccessBaseResponse(tProfileResponse));

      // Act
      final result = await repository.getProfileData();

      // Assert
      expect(result, isA<SuccessBaseResponse<UserProfileEntity>>());
      expect((result as SuccessBaseResponse).data, tUserProfileEntity);
      verify(mockDataSource.getProfileData()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('error when user is null', () async {
      // Arrange
      when(mockDataSource.getProfileData()).thenAnswer(
        (_) async => SuccessBaseResponse(GetProfileResponse(user: null)),
      );

      // Act
      final result = await repository.getProfileData();

      // Assert
      expect(result, isA<ErrorBaseResponse<UserProfileEntity>>());
      expect(
        (result as ErrorBaseResponse).errorMessage,
        AppStrings.profileDataNotFound,
      );
      verify(mockDataSource.getProfileData()).called(1);
    });

    test('error casse when API call fails', () async {
      // Arrange
      const errorMessage = 'Network Error';
      when(
        mockDataSource.getProfileData(),
      ).thenAnswer((_) async => ErrorBaseResponse(errorMessage));

      // Act
      final result = await repository.getProfileData();

      // Assert
      expect(result, isA<ErrorBaseResponse<UserProfileEntity>>());
      expect((result as ErrorBaseResponse).errorMessage, errorMessage);
      verify(mockDataSource.getProfileData()).called(1);
    });
  });

  group('logout', () {
    test('logout success: clear cache and return success', () async {
      // Arrange
      when(
        mockDataSource.logout(),
      ).thenAnswer((_) async => SuccessBaseResponse<void>(null));
      when(
        mockSecureCacheHelper.deleteData(key: AppKeys.tokenKey),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, isA<SuccessBaseResponse<void>>());
      verify(mockDataSource.logout()).called(1);
      verify(mockSecureCacheHelper.deleteData(key: AppKeys.tokenKey)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('logout failure: still clear cache and return error', () async {
      // Arrange
      when(
        mockDataSource.logout(),
      ).thenAnswer((_) async => ErrorBaseResponse<void>('Logout Failed'));
      when(
        mockSecureCacheHelper.deleteData(key: AppKeys.tokenKey),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, isA<ErrorBaseResponse<void>>());
      verify(mockDataSource.logout()).called(1);
      verify(mockSecureCacheHelper.deleteData(key: AppKeys.tokenKey)).called(1);
    });
  });
}
