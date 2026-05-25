import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'pagination_model.dart';

part 'get_all_products_response.g.dart';

@JsonSerializable()
class GetAllProductsResponse extends Equatable {
  final String? message;
  final PaginationModel? pagination;
  final List<ProductModel>? products;

  const GetAllProductsResponse({this.message, this.pagination, this.products});

  factory GetAllProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllProductsResponseToJson(this);

  @override
  List<Object?> get props => [message, pagination, products];
}
