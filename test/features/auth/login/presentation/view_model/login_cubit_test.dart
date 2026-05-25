import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_cubit.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([LoginUseCase, SecureCacheHelper])
void main() {
  late MockLoginUseCase mockUseCase;
  late MockSecureCacheHelper mockCache;

  // Test data
  final user = UserEntity(
    token: '123',
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    gender: '',
    phone: '',
    photo: '',
    role: '',
    createdAt: '',
  );

  setUpAll(() {
    provideDummy<BaseResponse<UserEntity>>(
      SuccessBaseResponse(
        UserEntity(
          token: 'dummy',
          id: '',
          firstName: '',
          lastName: '',
          email: '',
          gender: '',
          phone: '',
          photo: '',
          role: '',
          createdAt: '',
        ),
      ),
    );
  });

  setUp(() {
    mockUseCase = MockLoginUseCase();
    mockCache = MockSecureCacheHelper();
  });

  LoginCubit buildCubit() => LoginCubit(mockUseCase, mockCache);

  group('LoginCubit Tests', () {
    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] and saves token when rememberMe = true',
      setUp: () {
        when(
          mockUseCase.call(any),
        ).thenAnswer((_) async => SuccessBaseResponse(user));
        when(
          mockCache.writeData(key: anyNamed('key'), value: anyNamed('value')),
        ).thenAnswer((_) async {});
      },
      build: buildCubit,
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(
          email: 'test@test.com',
          password: '12345678',
          isRememberMe: true,
        ),
      ),
      expect: () => [
        isA<LoginState>().having((s) => s.isLoading, 'loading', true),
        isA<LoginState>().having((s) => s.user, 'user', isNotNull),
      ],
      verify: (_) {
        verify(
          mockCache.writeData(key: AppKeys.tokenKey, value: '123'),
        ).called(1);
        verify(
          mockCache.writeData(key: AppKeys.rememberMeKey, value: 'true'),
        ).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, error] when login fails',
      setUp: () {
        when(
          mockUseCase.call(any),
        ).thenAnswer((_) async => ErrorBaseResponse('Wrong credentials'));
      },
      build: buildCubit,
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(
          email: 'wrong@test.com',
          password: '123',
          isRememberMe: false,
        ),
      ),
      expect: () => [
        isA<LoginState>().having((s) => s.isLoading, 'loading', true),
        isA<LoginState>().having(
          (s) => s.errorMessage,
          'error',
          'Wrong credentials',
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'toggles password visibility',
      build: buildCubit,
      act: (bloc) => bloc.add(const TogglePasswordVisibilityEvent()),
      expect: () => [
        isA<LoginState>().having((s) => s.isPasswordObscure, 'obscure', false),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'saves token but rememberMe = false when rememberMe is false',
      setUp: () {
        when(
          mockUseCase.call(any),
        ).thenAnswer((_) async => SuccessBaseResponse(user));
        when(
          mockCache.writeData(key: anyNamed('key'), value: anyNamed('value')),
        ).thenAnswer((_) async {});
      },
      build: buildCubit,
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(
          email: 'test@test.com',
          password: '12345678',
          isRememberMe: false,
        ),
      ),
      expect: () => [
        isA<LoginState>().having((s) => s.isLoading, 'loading', true),
        isA<LoginState>().having((s) => s.user, 'user', isNotNull),
      ],
      verify: (_) {
        verify(
          mockCache.writeData(key: AppKeys.tokenKey, value: '123'),
        ).called(1);
        verify(
          mockCache.writeData(key: AppKeys.rememberMeKey, value: 'false'),
        ).called(1);
      },
    );
  });
}
