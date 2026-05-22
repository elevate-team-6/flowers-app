import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/product_details/domain/entities/product_details_entity.dart';

class ProductDetailsState extends Equatable {
  final BaseState<ProductDetailsEntity> productDetailsState;

  const ProductDetailsState({this.productDetailsState = const BaseState()});
  ProductDetailsState copyWith({
    BaseState<ProductDetailsEntity>? productDetailsState,
  }) {
    return ProductDetailsState(
      productDetailsState: productDetailsState ?? this.productDetailsState,
    );
  }

  @override
  List<Object> get props => [productDetailsState];
}
