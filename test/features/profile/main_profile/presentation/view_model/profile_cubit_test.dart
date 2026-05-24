import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:flowers_app/features/profile/main_profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:flowers_app/features/profile/main_profile/domain/use_cases/logout_use_case.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_cubit.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_events.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_states.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([GetProfileDataUseCase, LogoutUseCase])
void main() {
  late ProfileCubit cubit;
  late MockGetProfileDataUseCase mockGetProfileDataUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<UserProfileEntity>>(
      SuccessBaseResponse(const UserProfileEntity()),
    );
    provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(null));
  });

  setUp(() {
    mockGetProfileDataUseCase = MockGetProfileDataUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    cubit = ProfileCubit(mockGetProfileDataUseCase, mockLogoutUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const tUserEntity = UserProfileEntity(id: '1', firstName: 'John');

  group('getProfileData', () {
    blocTest<ProfileCubit, ProfileStates>(
      'success with user data',
      build: () {
        when(
          mockGetProfileDataUseCase.call(),
        ).thenAnswer((_) async => SuccessBaseResponse(tUserEntity));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(GetProfileDataEvent()),
      expect: () => [
        const ProfileStates(profileDataState: BaseState(isLoading: true)),
        const ProfileStates(
          profileDataState: BaseState(isLoading: false, data: tUserEntity),
        ),
      ],
      verify: (_) => verify(mockGetProfileDataUseCase.call()).called(1),
    );

    blocTest<ProfileCubit, ProfileStates>(
      'error fetching data',
      build: () {
        when(
          mockGetProfileDataUseCase.call(),
        ).thenAnswer((_) async => ErrorBaseResponse('Error message'));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(GetProfileDataEvent()),
      expect: () => [
        const ProfileStates(profileDataState: BaseState(isLoading: true)),
        const ProfileStates(
          profileDataState: BaseState(
            isLoading: false,
            errorMessage: 'Error message',
          ),
        ),
      ],
    );
  });

  group('logout', () {
    blocTest<ProfileCubit, ProfileStates>(
      'logout success',
      build: () {
        when(
          mockLogoutUseCase.logout(),
        ).thenAnswer((_) async => SuccessBaseResponse<void>(null));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(LogoutEvent()),
      expect: () => [
        const ProfileStates(logoutState: BaseState(isLoading: true)),
        const ProfileStates(logoutState: BaseState(isLoading: false)),
      ],
      verify: (_) => verify(mockLogoutUseCase.logout()).called(1),
    );

    blocTest<ProfileCubit, ProfileStates>(
      'logout failure',
      build: () {
        when(
          mockLogoutUseCase.logout(),
        ).thenAnswer((_) async => ErrorBaseResponse<void>('Logout error'));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(LogoutEvent()),
      expect: () => [
        const ProfileStates(logoutState: BaseState(isLoading: true)),
        const ProfileStates(
          logoutState: BaseState(
            isLoading: false,
            errorMessage: 'Logout error',
          ),
        ),
      ],
    );
  });

  group('toggleNotification', () {
    blocTest<ProfileCubit, ProfileStates>(
      'update notification status',
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const ToggleNotificationEvent(false)),
      expect: () => [const ProfileStates(isNotificationEnabled: false)],
    );
  });
}
