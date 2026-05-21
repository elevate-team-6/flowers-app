import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String imgCover;
  final int price;
  final int priceAfterDiscount;
  final int discount;
  final String description;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.imgCover,
    required this.price,
    required this.priceAfterDiscount,
    required this.discount,
    required this.description,
  });

  static const empty = ProductEntity(
    id: '',
    title: '',
    imgCover: '',
    price: 0,
    priceAfterDiscount: 0,
    discount: 0,
    description: '',
  );

  factory ProductEntity.fromJson(Map<String, dynamic> json) => ProductEntity(
    id: json['_id'] as String? ?? json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    imgCover: json['imgCover'] as String? ?? '',
    price: (json['price'] as num?)?.toInt() ?? 0,
    priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toInt() ?? 0,
    discount: (json['discount'] as num?)?.toInt() ?? 0,
    description: json['description'] as String? ?? '',
  );

  @override
  List<Object?> get props => [
    id,
    title,
    imgCover,
    price,
    priceAfterDiscount,
    discount,
    description,
  ];
}
