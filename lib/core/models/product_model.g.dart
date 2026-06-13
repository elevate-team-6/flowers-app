// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['_id'] as String?,
  title: json['title'] as String?,
  slug: json['slug'] as String?,
  description: json['description'] as String?,
  imgCover: json['imgCover'] as String?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  price: (json['price'] as num?)?.toInt(),
  priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toInt(),
  discount: (json['discount'] as num?)?.toInt(),
  rateAvg: (json['rateAvg'] as num?)?.toDouble(),
  rateCount: (json['rateCount'] as num?)?.toInt(),
  sold: (json['sold'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  category: json['category'] as String?,
  occasion: json['occasion'] as String?,
  isSuperAdmin: json['isSuperAdmin'] as bool?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  favoriteId: json['favoriteId'] as String?,
  isInWishlist: json['isInWishlist'] as bool?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'imgCover': instance.imgCover,
      'images': instance.images,
      'price': instance.price,
      'priceAfterDiscount': instance.priceAfterDiscount,
      'discount': instance.discount,
      'rateAvg': instance.rateAvg,
      'rateCount': instance.rateCount,
      'sold': instance.sold,
      'quantity': instance.quantity,
      'category': instance.category,
      'occasion': instance.occasion,
      'isSuperAdmin': instance.isSuperAdmin,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'favoriteId': instance.favoriteId,
      'isInWishlist': instance.isInWishlist,
    };
