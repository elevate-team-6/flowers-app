import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';

abstract class CategoriesEvent extends Equatable {
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
