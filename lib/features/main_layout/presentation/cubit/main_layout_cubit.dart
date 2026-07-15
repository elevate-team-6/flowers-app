import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'main_layout_event.dart';
import 'main_layout_state.dart';

@injectable
class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit() : super(const MainLayoutState());

  void doEvent(MainLayoutEvent event) {
    switch (event) {
      case ChangeIndexEvent():
        _changeIndex(event.index);
    }
  }

  void _changeIndex(int index) {
    emit(MainLayoutState(currentIndex: index));
  }
}
