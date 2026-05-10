import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'main_layout_intent.dart';
import 'main_layout_state.dart';

@injectable
class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit() : super(const MainLayoutState());

  void doIntent(MainLayoutIntent intent) {
    switch (intent) {
      case ChangeIndexIntent():
        _changeIndex(intent.index);
    }
  }

  void _changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
