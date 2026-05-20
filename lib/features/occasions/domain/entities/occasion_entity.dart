import 'package:equatable/equatable.dart';

class OccasionEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String image;
  final int productsCount;

  const OccasionEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.productsCount,
  });

  @override
  List<Object?> get props => [id, name, slug, image, productsCount];
}
