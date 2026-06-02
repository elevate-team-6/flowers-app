import 'dart:async';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/config/cache/hive_helper.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/search/domain/use_cases/search_products_use_case.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_event.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchCubit extends Cubit<SearchStates> {
  final SearchProductsUseCase _searchProductsUseCase;
  final HiveHelper _hiveHelper;
  Timer? _debounce;

  SearchCubit(this._searchProductsUseCase, this._hiveHelper)
    : super(const SearchStates()) {
    doEvent(const GetSearchHistoryEvent());
  }

  void doEvent(SearchEvent event) {
    switch (event) {
      case SearchQueryChangedEvent():
        _onSearchQueryChanged(event.query);
      case GetSearchHistoryEvent():
        _onGetSearchHistory();
      case RemoveSearchQueryEvent():
        _onRemoveSearchQuery(event.query);
      case ClearSearchHistoryEvent():
        _onClearSearchHistory();
    }
  }

  void _onSearchQueryChanged(String query) {
    emit(state.copyWith(searchQuery: query));
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _searchProducts(query);
      } else {
        emit(state.copyWith(searchProductsState: const BaseState()));
      }
    });
  }

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) return;

    emit(state.copyWith(searchProductsState: const BaseState(isLoading: true)));

    final result = await _searchProductsUseCase(
      GetProductsParams(search: query),
    );

    switch (result) {
      case SuccessBaseResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            searchProductsState: BaseState(isLoading: false, data: result.data),
          ),
        );
        if (result.data.isNotEmpty) {
          _saveSearchQuery(query);
        }
      case ErrorBaseResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            searchProductsState: BaseState(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _onGetSearchHistory() async {
    final history = await _hiveHelper.getData<List<dynamic>>(
      boxName: AppKeys.searchHistoryBox,
      key: AppKeys.searchHistoryKey,
    );
    if (history != null) {
      emit(state.copyWith(searchHistory: history.cast<String>()));
    }
  }

  Future<void> _saveSearchQuery(String query) async {
    List<String> history = List.from(state.searchHistory);
    if (history.contains(query)) {
      history.remove(query);
    }
    history.insert(0, query);
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }
    await _hiveHelper.cacheData(
      boxName: AppKeys.searchHistoryBox,
      key: AppKeys.searchHistoryKey,
      value: history,
    );
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onRemoveSearchQuery(String query) async {
    List<String> history = List.from(state.searchHistory);
    history.remove(query);
    await _hiveHelper.cacheData(
      boxName: AppKeys.searchHistoryBox,
      key: AppKeys.searchHistoryKey,
      value: history,
    );
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onClearSearchHistory() async {
    await _hiveHelper.clearBox(boxName: AppKeys.searchHistoryBox);
    emit(state.copyWith(searchHistory: []));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
