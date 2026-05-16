import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'main_layout_event.dart';
import 'main_layout_state.dart';

@injectable
class MainLayoutCubit extends Cubit<MainLayoutState> {
  String? categoryId;
  MainLayoutCubit() : super(const MainLayoutState());

  void doEvent(MainLayoutEvent event) {
    switch (event) {
      case ChangeIndexEvent():
        if (event.categoryId != null) {
          categoryId = event.categoryId;
        } else {
          categoryId = null;
        }
        _changeIndex(event.index);
    }
  }

  void _changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
