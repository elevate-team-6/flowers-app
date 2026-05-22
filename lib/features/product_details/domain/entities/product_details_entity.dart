import 'package:equatable/equatable.dart';

class ProductDetailsEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imgCover;
  final List<String> images;
  final int price;
  final int quantity;

  const ProductDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imgCover,
    required this.images,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    imgCover,
    price,
    description,
    quantity,
    images,
  ];
}
