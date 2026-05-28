import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/entities/product_entity.dart';

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

  ProductEntity toProductEntity() => ProductEntity(
    id: id,
    title: title,
    imgCover: imgCover,
    price: price,
    priceAfterDiscount: price,
    discount: 0,
    description: description,
  );

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
