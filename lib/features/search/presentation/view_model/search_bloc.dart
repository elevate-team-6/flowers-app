import 'dart:async';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/search/domain/use_cases/clear_search_history_use_case.dart';
import 'package:flowers_app/features/search/domain/use_cases/get_search_history_use_case.dart';
import 'package:flowers_app/features/search/domain/use_cases/save_search_query_use_case.dart';
import 'package:flowers_app/features/search/domain/use_cases/search_products_use_case.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_event.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchStates> {
  final SearchProductsUseCase _searchProductsUseCase;
  final GetSearchHistoryUseCase _getSearchHistoryUseCase;
  final SaveSearchHistoryUseCase _saveSearchHistoryUseCase;
  final ClearSearchHistoryUseCase _clearSearchHistoryUseCase;

  Timer? _debounce;
  static const int _maxHistoryItems = 10;

  SearchBloc(
    this._searchProductsUseCase,
    this._getSearchHistoryUseCase,
    this._saveSearchHistoryUseCase,
    this._clearSearchHistoryUseCase,
  ) : super(const SearchStates()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<GetSearchHistoryEvent>(_onGetSearchHistory);
    on<RemoveSearchQueryEvent>(_onRemoveSearchQuery);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);

    add(const GetSearchHistoryEvent());
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchStates> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    final completer = Completer<void>();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      completer.complete();
    });

    await completer.future;

    if (event.query.isNotEmpty) {
      await _searchProducts(event.query, emit);
    } else {
      emit(state.copyWith(searchProductsState: const BaseState()));
    }
  }

  Future<void> _searchProducts(String query, Emitter<SearchStates> emit) async {
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
          await _saveSearchQuery(query, emit);
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

  Future<void> _onGetSearchHistory(
    GetSearchHistoryEvent event,
    Emitter<SearchStates> emit,
  ) async {
    final history = await _getSearchHistoryUseCase();
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _saveSearchQuery(
    String query,
    Emitter<SearchStates> emit,
  ) async {
    List<String> history = List.from(state.searchHistory);
    if (history.contains(query)) {
      history.remove(query);
    }
    history.insert(0, query);
    if (history.length > _maxHistoryItems) {
      history = history.sublist(0, _maxHistoryItems);
    }
    await _saveSearchHistoryUseCase(history);
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onRemoveSearchQuery(
    RemoveSearchQueryEvent event,
    Emitter<SearchStates> emit,
  ) async {
    List<String> history = List.from(state.searchHistory);
    history.remove(event.query);
    await _saveSearchHistoryUseCase(history);
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistoryEvent event,
    Emitter<SearchStates> emit,
  ) async {
    await _clearSearchHistoryUseCase();
    emit(state.copyWith(searchHistory: []));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
