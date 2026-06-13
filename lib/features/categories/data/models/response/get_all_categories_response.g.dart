// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_categories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCategoriesResponse _$GetAllCategoriesResponseFromJson(
  Map<String, dynamic> json,
) => GetAllCategoriesResponse(
  message: json['message'] as String?,
  pagination: json['pagination'] == null
      ? null
      : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetAllCategoriesResponseToJson(
  GetAllCategoriesResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'pagination': instance.pagination,
  'categories': instance.categories,
};
