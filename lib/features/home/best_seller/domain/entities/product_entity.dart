import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;

  final String imgCover;
  final List<String> images;

  final int price;
  final int priceAfterDiscount;
  final int discount;

  final num rateAvg;
  final int rateCount;

  final int sold;
  final int quantity;

  final String categoryId;
  final String occasionId;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imgCover,
    required this.images,
    required this.price,
    required this.priceAfterDiscount,
    required this.discount,
    required this.rateAvg,
    required this.rateCount,
    required this.sold,
    required this.quantity,
    required this.categoryId,
    required this.occasionId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imgCover,
    images,
    price,
    priceAfterDiscount,
    discount,
    rateAvg,
    rateCount,
    sold,
    quantity,
    categoryId,
    occasionId,
  ];
}
