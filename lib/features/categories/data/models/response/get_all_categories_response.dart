import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';
import 'metadata_model.dart';

part 'get_all_categories_response.g.dart';

@JsonSerializable()
class GetAllCategoriesResponse extends Equatable {
  final String? message;
  final MetadataModel? metadata;
  final List<CategoryModel>? categories;

  const GetAllCategoriesResponse({
    this.message,
    this.metadata,
    this.categories,
  });

  factory GetAllCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllCategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCategoriesResponseToJson(this);

  CategoriesEntity toEntity() => CategoriesEntity(
        categories: categories?.map((c) => c.toEntity()).toList(),
      );

  @override
  List<Object?> get props => [message, metadata, categories];
}
