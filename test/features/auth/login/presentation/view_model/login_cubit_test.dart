import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_cubit.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/login/domain/use_cases/login_use_case.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([LoginUseCase, CacheHelper])
void main() {
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

  late LoginCubit bloc;
  late MockLoginUseCase mockUseCase;
  late MockCacheHelper mockCache;

  setUp(() {
    mockUseCase = MockLoginUseCase();
    mockCache = MockCacheHelper();
    bloc = LoginCubit(mockUseCase, mockCache);
  });

  tearDown(() {
    bloc.close();
  });

  group('LoginCubit Tests', () {
    blocTest<LoginCubit, LoginState>(
      'should emit [loading, success] and save token when rememberMe = true',
      build: () {
        when(mockUseCase.call(any)).thenAnswer(
          (_) async => SuccessBaseResponse(
            UserEntity(
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
            ),
          ),
        );

        when(mockCache.writeData(
          key: anyNamed('key'),
          value: anyNamed('value'),
        )).thenAnswer((_) async {});

        return bloc;
      },
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
        verify(mockCache.writeData(
          key: AppKeys.tokenKey,
          value: '123',
        )).called(1);

        verify(mockCache.writeData(
          key: AppKeys.rememberMeKey,
          value: 'true',
        )).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'should emit [loading, error] when login fails',
      build: () {
        when(mockUseCase.call(any)).thenAnswer(
          (_) async => ErrorBaseResponse('Wrong credentials'),
        );
        return bloc;
      },
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
      'should toggle password visibility',
      build: () => bloc,
      act: (bloc) => bloc.add(const TogglePasswordVisibilityEvent()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.isPasswordObscure,
          'obscure',
          false,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'should NOT save token when rememberMe = false',
      build: () {
        when(mockUseCase.call(any)).thenAnswer(
          (_) async => SuccessBaseResponse(
            UserEntity(
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
            ),
          ),
        );

        when(mockCache.deleteData(key: anyNamed('key')))
            .thenAnswer((_) async {});

        when(mockCache.writeData(
          key: anyNamed('key'),
          value: anyNamed('value'),
        )).thenAnswer((_) async {});

        return bloc;
      },
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
        verify(mockCache.deleteData(key: AppKeys.tokenKey)).called(1);

        verify(mockCache.writeData(
          key: AppKeys.rememberMeKey,
          value: 'false',
        )).called(1);
      },
    );
  });
}