import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/use_cases/occasions_use_case.dart';
import 'package:flowers_app/features/occasions/domain/use_cases/get_products_use_case.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_events.dart';

@injectable
class OccasionsCubit extends Cubit<OccasionsState> {
  final OccasionsUseCase _occasionsUseCase;
  final GetProductsUseCase _getProductsUseCase;

  OccasionsCubit(this._occasionsUseCase, this._getProductsUseCase)
    : super(OccasionsState());

  Future<void> doEvent(OccasionsEvents event) async {
    switch (event) {
      case GetOccasionsEvent():
        await _getOccasions();
      case GetProductsEvent():
        await _getProducts(event.occasionName);
    }
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
              data: result.data,
            ),
          ),
        );
      case ErrorBaseResponse<List<OccasionEntity>>():
        emit(
          state.copyWith(
            occasionsStateParam: BaseState<List<OccasionEntity>>(
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _getProducts(String occasionName) async {
   emit(
    state.copyWith(
      productsStateParam: BaseState<List<ProductEntity>>(
        isLoading: true,
        data: state.productsState.data,
      ),
    ),
  );

    final result = await _getProductsUseCase(occasionName);

    switch (result) {
      case SuccessBaseResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsStateParam: BaseState<List<ProductEntity>>(
              data: result.data,
            ),
          ),
        );
      case ErrorBaseResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsStateParam: BaseState<List<ProductEntity>>(
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }
}
