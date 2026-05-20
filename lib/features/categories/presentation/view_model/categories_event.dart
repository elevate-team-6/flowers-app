import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';

sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoriesRequestedEvent extends CategoriesEvent {
  const GetCategoriesRequestedEvent();
}

class GetProductsRequestedEvent extends CategoriesEvent {
  final GetProductsParams? params;

  const GetProductsRequestedEvent({this.params});

  @override
  List<Object?> get props => [params];
}

class CategoryChangedEvent extends CategoriesEvent {
  final String? categoryId;
  const CategoryChangedEvent(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class SearchChangedEvent extends CategoriesEvent {
  final String? query;
  const SearchChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class FilterChangedEvent extends CategoriesEvent {
  final String? sort;
  const FilterChangedEvent(this.sort);
  @override
  List<Object?> get props => [sort];
}
