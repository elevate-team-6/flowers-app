import 'package:flowers_app/features/home/best_seller/domain/entities/product_entity.dart';

class ProductModel {
  final String? id;
  final String? title;
  final String? slug;
  final String? description;

  final String? imgCover;
  final List<String>? images;

  final int? price;
  final int? priceAfterDiscount;
  final int? discount;

  final num? rateAvg;
  final int? rateCount;

  final int? sold;
  final int? quantity;

  final String? category;
  final String? occasion;

  final bool? isSuperAdmin;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
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
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      imgCover: json['imgCover'],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),

      price: json['price'],
      priceAfterDiscount: json['priceAfterDiscount'],
      discount: json['discount'],

      rateAvg: json['rateAvg'],
      rateCount: json['rateCount'],

      sold: json['sold'],
      quantity: json['quantity'],

      category: json['category'],
      occasion: json['occasion'],

      isSuperAdmin: json['isSuperAdmin'],

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id ?? '',
      title: title ?? '',
      description: description ?? '',

      imgCover: imgCover ?? '',
      images: images ?? [],

      price: price ?? 0,
      priceAfterDiscount: priceAfterDiscount ?? 0,
      discount: discount ?? 0,

      rateAvg: rateAvg ?? 0,
      rateCount: rateCount ?? 0,

      sold: sold ?? 0,
      quantity: quantity ?? 0,

      categoryId: category ?? '',
      occasionId: occasion ?? '',
    );
  }
}
