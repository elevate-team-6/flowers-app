import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/config/entities/product_entity.dart';

class ProductDetailsState extends Equatable {
  final BaseState<ProductEntity> productDetailsState;

  const ProductDetailsState({this.productDetailsState = const BaseState()});
  ProductDetailsState copyWith({
    BaseState<ProductEntity>? productDetailsState,
  }) {
    return ProductDetailsState(
      productDetailsState: productDetailsState ?? this.productDetailsState,
    );
  }

  @override
  List<Object> get props => [productDetailsState];
}
