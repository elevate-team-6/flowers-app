import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/home/presentation/view_model/events/home_events.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/entities/product_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeStates> {
  final OccasionsUseCase _occasionsUseCase;
  final CategoriesUseCase _categeoriesUseCase;
  final BestSellerUseCase _bestSellerUseCase;
  HomeViewModel(
    this._occasionsUseCase,
    this._categeoriesUseCase,
    this._bestSellerUseCase,
  ) : super(HomeStates());

  void doEvent(HomeEvents event) {
    switch (event) {
      case GetAllHomeData():
        _getAllData();
    }
  }

  Future<void> _getAllData() async {
    Future.wait([_getOccasions(), _getBestSeller(), _getCategories()]);
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

  Future<void> _getBestSeller() async {
    emit(
      state.copyWith(
        bsetSelerStateParam: BaseState<List<ProductEntity>>(isLoading: true),
      ),
    );
    final result = await _bestSellerUseCase();
    switch (result) {
      case SuccessBaseResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            bsetSelerStateParam: BaseState<List<ProductEntity>>(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
        break;
      case ErrorBaseResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            bsetSelerStateParam: BaseState(errorMessage: result.errorMessage),
          ),
        );
    }
  }

  Future<void> _getCategories() async {
    emit(
      state.copyWith(
        categoreyStateParam: BaseState<List<CategoryEntity>>(isLoading: true),
      ),
    );
    final result = await _bestSellerUseCase();
    switch (result) {
      case SuccessBaseResponse<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoreyStateParam: BaseState<List<CategoryEntity>>(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
        break;
      case ErrorBaseResponse<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoreyStateParam: BaseState(errorMessage: result.errorMessage),
          ),
        );
    }
  }
}
