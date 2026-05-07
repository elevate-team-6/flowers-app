// test/features/auth/signup/presentation/view_model/signup_cubit_test.dart
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/signup/domain/ues_cases/signup_use_case.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_cubit.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_events.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockSignupUseCase extends Mock implements SignupUseCase {}

void main() {
  late MockSignupUseCase mockUseCase;
  late SignupCubit cubit;

  setUp(() {
    mockUseCase = MockSignupUseCase();
    cubit = SignupCubit(mockUseCase);
  });

  tearDown(() => cubit.close());

  group('SignupEvent', () {
    final request = SignupRequest(
      firstName: 'ahmed',
      lastName: 'emam',
      email: 'test@test.com',
      password: 'Ahmed@123',
      rePassword: 'Ahmed@123',
      phone: '+201234567890',
      gender: 'male',
    );

    blocTest<SignupCubit, SignupState>(
      'emits loading then success',
      build: () {
        when(() => mockUseCase(request)).thenAnswer(
          (_) async => SuccessBaseResponse(
            UserEntity(
              id: '1',
              firstName: 'ahmed',
              lastName: 'emam',
              email: 'test@test.com',
              gender: 'male',
              phone: '+201234567890',
              photo: '',
              role: 'user',
              createdAt: '2025-01-01',
            ),
          ),
        );
        return cubit;
      },
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
      build: () {
        when(
          () => mockUseCase(request),
        ).thenAnswer((_) async => ErrorBaseResponse('user already exists'));
        return cubit;
      },
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
