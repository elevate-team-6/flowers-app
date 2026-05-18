import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';

class OccasionModel extends Equatable {
  final String? id;
  final String? name;
  final String? slug;
  final String? image;
  final int? productsCount;

  const OccasionModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.productsCount,
  });

  factory OccasionModel.fromJson(Map<String, dynamic> json) => OccasionModel(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    slug: json['slug'] as String?,
    image: json['image'] as String?,
    productsCount: json['productsCount'] as int?,
  );

  OccasionEntity toEntity() => OccasionEntity(
    id: id ?? '',
    name: name ?? '',
    slug: slug ?? '',
    image: image != null && image!.startsWith('http')
        ? image!
        : '${AppImages.imageBaseUrl}${image ?? ''}',
    productsCount: productsCount ?? 0,
  );

  @override
  List<Object?> get props => [id, name, slug, image, productsCount];
}
