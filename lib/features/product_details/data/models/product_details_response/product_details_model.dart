import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/product_details/domain/entities/product_details_entity.dart';

class ProductDetailsModel extends Equatable {
  final String? id;
  final String? title;
  final String? slug;
  final String? description;
  final String? imgCover;
  final List<String>? images;
  final int? price;
  final int? priceAfterDiscount;
  final int? discount;
  final double? rateAvg;
  final int? rateCount;
  final int? sold;
  final int? quantity;
  final String? category;
  final String? occasion;
  final bool? isSuperAdmin;
  final String? createdAt;
  final String? updatedAt;
  final String? favoriteId;
  final bool? isInWishlist;

  const ProductDetailsModel({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.discount,
    this.rateAvg,
    this.rateCount,
    this.sold,
    this.quantity,
    this.category,
    this.occasion,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.favoriteId,
    this.isInWishlist,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        slug: json['slug'] as String?,
        description: json['description'] as String?,
        imgCover: json['imgCover'] as String?,
        images: (json['images'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        price: json['price'] as int?,
        priceAfterDiscount: json['priceAfterDiscount'] as int?,
        discount: json['discount'] as int?,
        rateAvg: (json['rateAvg'] as num?)?.toDouble(),
        rateCount: json['rateCount'] as int?,
        sold: json['sold'] as int?,
        quantity: json['quantity'] as int?,
        category: json['category'] as String?,
        occasion: json['occasion'] as String?,
        isSuperAdmin: json['isSuperAdmin'] as bool?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        favoriteId: json['favoriteId'] as String?,
        isInWishlist: json['isInWishlist'] as bool?,
      );

  ProductDetailsEntity toEntity() => ProductDetailsEntity(
    id: id ?? '',
    title: title ?? '',
    imgCover: imgCover ?? '',
    price: price ?? 0,
    description: description ?? '',
    images: images ?? [],
    quantity: quantity ?? 0,
  );

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
