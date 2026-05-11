import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/signup/domain/ues_cases/signup_use_case.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_cubit.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_events.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'signup_cubit_test.mocks.dart';

@GenerateMocks([SignupUseCase])
void main() {
  late MockSignupUseCase mockUseCase;
  late SignupCubit cubit;

  final request = SignupRequest(
    firstName: 'ahmed',
    lastName: 'emam',
    email: 'test@test.com',
    password: 'Ahmed@123',
    rePassword: 'Ahmed@123',
    phone: '+201234567890',
    gender: 'male',
  );

  final fakeUser = UserEntity(
    id: '1',
    firstName: 'ahmed',
    lastName: 'emam',
    email: 'test@test.com',
    gender: 'male',
    phone: '+201234567890',
    photo: '',
    role: 'user',
    createdAt: '2025-01-01',
  );

  setUp(() {
    mockUseCase = MockSignupUseCase();
    cubit = SignupCubit(mockUseCase);

    provideDummy<BaseResponse<UserEntity>>(ErrorBaseResponse('dummy'));
  });

  tearDown(() => cubit.close());

  group('SignupEvent', () {
    blocTest<SignupCubit, SignupState>(
      'emits loading then success',
      setUp: () {
        when(
          mockUseCase(request),
        ).thenAnswer((_) async => SuccessBaseResponse(fakeUser));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(SignupEvent(request)),
      expect: () => [
        isA<SignupState>().having(
          (s) => s.signupState.isLoading,
          'isLoading',
          true,
        ),
        isA<SignupState>().having((s) => s.signupState.data, 'data', isNotNull),
      ],
    );

    blocTest<SignupCubit, SignupState>(
      'emits loading then failure',
      setUp: () {
        when(
          mockUseCase(request),
        ).thenAnswer((_) async => ErrorBaseResponse('user already exists'));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(SignupEvent(request)),
      expect: () => [
        isA<SignupState>().having(
          (s) => s.signupState.isLoading,
          'isLoading',
          true,
        ),
        isA<SignupState>().having(
          (s) => s.signupState.errorMessage,
          'errorMessage',
          'user already exists',
        ),
      ],
    );
  });
}
