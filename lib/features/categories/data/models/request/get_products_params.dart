import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_products_params.g.dart';

@JsonSerializable()
class GetProductsParams extends Equatable {
  final String? sort;
  final String? search;
  final int? limit;
  final int? page;
  final String? category;
  final String? occasion;

  const GetProductsParams({
    this.sort,
    this.search,
    this.limit,
    this.page,
    this.category,
    this.occasion,
  });

  factory GetProductsParams.fromJson(Map<String, dynamic> json) =>
      _$GetProductsParamsFromJson(json);

  Map<String, dynamic> toJson() => _$GetProductsParamsToJson(this);

  @override
  List<Object?> get props => [sort, search, limit, page, category, occasion];
}
