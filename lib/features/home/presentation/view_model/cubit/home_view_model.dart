import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_events.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/use_cases/occasions_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeStates> {
  final OccasionsUseCase _occasionsUseCase;
  HomeViewModel(this._occasionsUseCase) : super(HomeStates());

  void doEvent(HomeEvents event) {
    switch (event) {
      case GetAllHomeData():
        _getAllData();
    }
  }

  Future<void> _getAllData() async {
    Future.wait([_getOccasions()]);
  }

  Future<void> _getOccasions() async {
    emit(
      state.copyWith(
        occasionsStateParam: BaseState<List<OccasionEntity>>(isLoading: true),
      ),
    );
    final result = await _occasionsUseCase();
    switch (result) {
      case SuccessBaseResponse<List<OccasionEntity>>():
        emit(
          state.copyWith(
            occasionsStateParam: BaseState<List<OccasionEntity>>(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
        break;
      case ErrorBaseResponse<List<OccasionEntity>>():
        emit(
          state.copyWith(
            occasionsStateParam: BaseState(errorMessage: result.errorMessage),
          ),
        );
    }
  }
}
