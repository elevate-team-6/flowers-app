// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_products_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetProductsParams _$GetProductsParamsFromJson(Map<String, dynamic> json) =>
    GetProductsParams(
      sort: json['sort'] as String?,
      search: json['search'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      category: json['category'] as String?,
      occasion: json['occasion'] as String?,
    );

Map<String, dynamic> _$GetProductsParamsToJson(GetProductsParams instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'search': instance.search,
      'limit': instance.limit,
      'page': instance.page,
      'category': instance.category,
      'occasion': instance.occasion,
    };
