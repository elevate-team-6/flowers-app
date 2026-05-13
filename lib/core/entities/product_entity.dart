import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String imgCover;
  final int price;
  final int priceAfterDiscount;
  final int discount;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.imgCover,
    required this.price,
    required this.priceAfterDiscount,
    required this.discount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    imgCover,
    price,
    priceAfterDiscount,
    discount,
  ];
}
