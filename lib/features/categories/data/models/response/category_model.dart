import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Equatable {
  @JsonKey(name: "_id")
  final String? id;
  final String? name;
  final String? slug;
  final String? image;
  final bool? isSuperAdmin;
  final String? createdAt;
  final String? updatedAt;
  final int? productsCount;

  const CategoryModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  CategoryEntity toEntity() => CategoryEntity(id: id, name: name, image: image);

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    image,
    isSuperAdmin,
    createdAt,
    updatedAt,
    productsCount,
  ];
}
