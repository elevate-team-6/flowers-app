import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/main_profile/api/api_client/profile_api_client.dart';
import 'package:flowers_app/features/profile/main_profile/api/data_sources/profile_data_source_impl.dart';
import 'package:flowers_app/features/profile/main_profile/data/models/response/get_profile_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'profile_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late ProfileDataSourceImpl dataSource;
  late MockProfileApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockProfileApiClient();
    dataSource = ProfileDataSourceImpl(mockApiClient);
  });

  group('getProfileData', () {
    const tProfileResponse = GetProfileResponse(message: 'Success');

    test('success with profile data', () async {
      // Arrange
      when(
        mockApiClient.getProfileData(),
      ).thenAnswer((_) async => tProfileResponse);

      // Act
      final result = await dataSource.getProfileData();

      // Assert
      expect(result, isA<SuccessBaseResponse<GetProfileResponse>>());
      expect((result as SuccessBaseResponse).data, tProfileResponse);
      verify(mockApiClient.getProfileData()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('error when API call fails', () async {
      // Arrange
      when(
        mockApiClient.getProfileData(),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.getProfileData();

      // Assert
      expect(result, isA<ErrorBaseResponse<GetProfileResponse>>());
      verify(mockApiClient.getProfileData()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });

  group('logout', () {
    test('logout success', () async {
      // Arrange
      when(mockApiClient.logout()).thenAnswer((_) async => Future.value());

      // Act
      final result = await dataSource.logout();

      // Assert
      expect(result, isA<SuccessBaseResponse<void>>());
      verify(mockApiClient.logout()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('logout failure', () async {
      // Arrange
      when(
        mockApiClient.logout(),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.logout();

      // Assert
      expect(result, isA<ErrorBaseResponse<void>>());
      verify(mockApiClient.logout()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
