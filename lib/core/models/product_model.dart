import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Equatable {
  @JsonKey(name: '_id')
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

  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductEntity toEntity() => ProductEntity(
        id: id ?? '',
        title: title ?? '',
        imgCover: imgCover ?? '',
        price: price ?? 0,
        priceAfterDiscount: priceAfterDiscount ?? 0,
        discount: discount ?? 0,
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
