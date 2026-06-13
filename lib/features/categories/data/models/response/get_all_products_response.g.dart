// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_products_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllProductsResponse _$GetAllProductsResponseFromJson(
  Map<String, dynamic> json,
) => GetAllProductsResponse(
  message: json['message'] as String?,
  pagination: json['pagination'] == null
      ? null
      : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
  products: (json['products'] as List<dynamic>?)
      ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetAllProductsResponseToJson(
  GetAllProductsResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'pagination': instance.pagination,
  'products': instance.products,
};
