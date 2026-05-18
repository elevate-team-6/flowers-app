import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/models/product_model.dart';

class ProductsResponse extends Equatable {
  final String? message;
  final List<ProductModel>? products;

  const ProductsResponse({this.message, this.products});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      ProductsResponse(
        message: json['message'] as String?,
        products: (json['products'] as List<dynamic>?)
            ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [message, products];
}
