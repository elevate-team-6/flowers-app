import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:flowers_app/features/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flowers_app/features/categories/domain/use_cases/get_products_use_case.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_event.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesStates> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;

  CategoriesCubit(this._getCategoriesUseCase, this._getProductsUseCase)
      : super(const CategoriesStates());

  void doEvent(CategoriesEvent event) {
    switch (event) {
      case GetCategoriesRequestedEvent():
        _onGetCategories();
        break;
      case GetProductsRequestedEvent(params: final params):
        _onGetProducts(params);
        break;
    }
  }

  Future<void> _onGetCategories() async {
    emit(state.copyWith(
      categoriesState: const BaseState(isLoading: true),
    ));

    final result = await _getCategoriesUseCase();

    switch (result) {
      case SuccessBaseResponse<CategoriesEntity>():
        emit(state.copyWith(
          categoriesState: BaseState(
            isLoading: false,
            data: result.data,
          ),
        ));
        break;
      case ErrorBaseResponse<CategoriesEntity>():
        emit(state.copyWith(
          categoriesState: BaseState(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        ));
        break;
    }
  }

  Future<void> _onGetProducts(GetProductsParams? params) async {
    emit(state.copyWith(
      productsState: const BaseState(isLoading: true),
    ));

    final result = await _getProductsUseCase(
      params: params ?? const GetProductsParams(),
    );

    switch (result) {
      case SuccessBaseResponse<List<ProductEntity>>():
        emit(state.copyWith(
          productsState: BaseState(
            isLoading: false,
            data: result.data,
          ),
        ));
        break;
      case ErrorBaseResponse<List<ProductEntity>>():
        emit(state.copyWith(
          productsState: BaseState(
            isLoading: false,
            errorMessage: result.errorMessage,
          ),
        ));
        break;
    }
  }
}
