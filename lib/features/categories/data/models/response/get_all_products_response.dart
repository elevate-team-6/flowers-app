import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'metadata_model.dart';

part 'get_all_products_response.g.dart';

@JsonSerializable()
class GetAllProductsResponse extends Equatable {
  final String? message;
  final MetadataModel? metadata;
  final List<ProductModel>? products;

  const GetAllProductsResponse({
    this.message,
    this.metadata,
    this.products,
  });

  factory GetAllProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllProductsResponseToJson(this);

  List<ProductEntity> toEntity() =>
      products?.map((p) => p.toEntity()).toList() ?? [];

  @override
  List<Object?> get props => [message, metadata, products];
}
