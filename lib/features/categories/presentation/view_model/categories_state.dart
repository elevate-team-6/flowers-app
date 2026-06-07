import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';

class CategoriesStates extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<List<ProductEntity>> productsState;
  final String categoryId;
  final String sort;

  const CategoriesStates({
    this.categoriesState = const BaseState(),
    this.productsState = const BaseState(),
    this.categoryId = 'all',
    this.sort = '',
  });

  CategoriesStates copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<List<ProductEntity>>? productsState,
    String? categoryId,
    String? sort,
  }) {
    return CategoriesStates(
      categoriesState: categoriesState ?? this.categoriesState,
      productsState: productsState ?? this.productsState,
      categoryId: categoryId ?? this.categoryId,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [categoriesState, productsState, categoryId, sort];
}
