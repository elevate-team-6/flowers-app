import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';

class CategoriesStates extends Equatable {
  final BaseState<CategoriesEntity> categoriesState;
  final BaseState<List<ProductEntity>> productsState;

  const CategoriesStates({
    this.categoriesState = const BaseState(),
    this.productsState = const BaseState(),
  });

  CategoriesStates copyWith({
    BaseState<CategoriesEntity>? categoriesState,
    BaseState<List<ProductEntity>>? productsState,
  }) {
    return CategoriesStates(
      categoriesState: categoriesState ?? this.categoriesState,
      productsState: productsState ?? this.productsState,
    );
  }

  @override
  List<Object?> get props => [categoriesState, productsState];
}
