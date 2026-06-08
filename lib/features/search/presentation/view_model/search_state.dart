import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';

class SearchStates extends Equatable {
  final BaseState<List<ProductEntity>> searchProductsState;
  final List<String> searchHistory;
  final String searchQuery;

  const SearchStates({
    this.searchProductsState = const BaseState(),
    this.searchHistory = const [],
    this.searchQuery = '',
  });

  SearchStates copyWith({
    BaseState<List<ProductEntity>>? searchProductsState,
    List<String>? searchHistory,
    String? searchQuery,
  }) {
    return SearchStates(
      searchProductsState: searchProductsState ?? this.searchProductsState,
      searchHistory: searchHistory ?? this.searchHistory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [searchProductsState, searchHistory, searchQuery];
}
