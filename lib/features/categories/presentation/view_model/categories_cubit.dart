import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flowers_app/features/categories/domain/use_cases/get_products_use_case.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_event.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/category_entity.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesStates> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;

  CategoriesCubit(this._getCategoriesUseCase, this._getProductsUseCase)
    : super(const CategoriesStates());

  void doEvent(CategoriesEvent event) {
    if (event is GetCategoriesRequestedEvent) {
      _onGetCategories();
    } else if (event is CategoryChangedEvent) {
      emit(state.copyWith(categoryId: event.categoryId ?? 'all'));
      _onGetProducts();
    } else if (event is SearchChangedEvent) {
      emit(state.copyWith(searchQuery: event.query));
      _onGetProducts();
    } else if (event is FilterChangedEvent) {
      emit(state.copyWith(sort: event.sort));
      _onGetProducts();
    } else if (event is GetProductsRequestedEvent) {
      _onGetProducts();
    }
  }

  Future<void> _onGetCategories() async {
    emit(
      state.copyWith(
        categoriesState: const BaseState<List<CategoryEntity>>(isLoading: true),
      ),
    );
    final result = await _getCategoriesUseCase();
    switch (result) {
      // (result is SuccessBaseResponse<List<CategoryEntity>>) {
      case SuccessBaseResponse<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: BaseState<List<CategoryEntity>>(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
      case ErrorBaseResponse<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: BaseState<List<CategoryEntity>>(
              isLoading: false,
              errorMessage: (result as ErrorBaseResponse).errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _onGetProducts() async {
    emit(state.copyWith(productsState: const BaseState(isLoading: true)));

    // تحويل نصوص الواجهة إلى قيم يفهمها الـ API
    String? apiSort;
    if (state.sort == AppStrings.highestPrice) {
      apiSort = '-price';
    } else if (state.sort == AppStrings.lowestPrice) {
      apiSort = 'price';
    } else if (state.sort == AppStrings.newText) {
      apiSort = '-createdAt';
    } else if (state.sort == AppStrings.oldText) {
      apiSort = 'createdAt';
    } else if (state.sort == AppStrings.discountText) {
      apiSort = '-discount';
    }

    final params = GetProductsParams(
      category: state.categoryId == 'all' ? null : state.categoryId,
      search: state.searchQuery.isEmpty ? null : state.searchQuery,
      sort: apiSort,
    );

    final result = await _getProductsUseCase(params: params);

    if (result is SuccessBaseResponse<List<ProductEntity>>) {
      emit(
        state.copyWith(
          productsState: BaseState(isLoading: false, data: result.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          productsState: BaseState(
            isLoading: false,
            errorMessage: (result as ErrorBaseResponse).errorMessage,
          ),
        ),
      );
    }
  }
}
