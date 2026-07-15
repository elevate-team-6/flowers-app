import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/features/main_layout/presentation/cubit/main_layout_cubit.dart';
import 'package:flowers_app/features/main_layout/presentation/cubit/main_layout_event.dart';
import 'package:flowers_app/features/main_layout/presentation/cubit/main_layout_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MainLayoutCubit', () {
    late MainLayoutCubit mainLayoutCubit;

    setUp(() {
      mainLayoutCubit = MainLayoutCubit();
    });

    tearDown(() {
      mainLayoutCubit.close();
    });

    test('initial state is correct', () {
      expect(mainLayoutCubit.state, const MainLayoutState(currentIndex: 0));
    });

    blocTest<MainLayoutCubit, MainLayoutState>(
      'emits [MainLayoutState(currentIndex: 1)] when ChangeIndexEvent(1) is added',
      build: () => mainLayoutCubit,
      act: (cubit) => cubit.doEvent(const ChangeIndexEvent(1)),
      expect: () => [const MainLayoutState(currentIndex: 1)],
    );

    blocTest<MainLayoutCubit, MainLayoutState>(
      'emits [MainLayoutState(currentIndex: 0)] when ChangeIndexEvent(0) is added',
      build: () => mainLayoutCubit,
      act: (cubit) => cubit.doEvent(const ChangeIndexEvent(0)),
      expect: () => [const MainLayoutState(currentIndex: 0)],
    );
  });
}
