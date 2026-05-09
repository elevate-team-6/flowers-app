import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String description;
  final String imgCover;
  final List<String> images;
  final int price;
  final int priceAfterDiscount;
  final int discount;
  final double rateAvg;
  final int rateCount;
  final int sold;
  final int quantity;
  final String category;
  final String occasion;
  final bool isSuperAdmin;
  final String createdAt;
  final String updatedAt;
  final String? favoriteId;
  final bool isInWishlist;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.slug,
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
    required this.category,
    required this.occasion,
    required this.isSuperAdmin,
    required this.createdAt,
    required this.updatedAt,
    this.favoriteId,
    required this.isInWishlist,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
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
    category,
    occasion,
    isSuperAdmin,
    createdAt,
    updatedAt,
    favoriteId,
    isInWishlist,
  ];
}
