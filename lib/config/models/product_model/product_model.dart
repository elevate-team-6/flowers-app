import 'package:flowers_app/config/entities/product_entity.dart';

class ProductModel {
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
    this.v,
    this.favoriteId,
    this.isInWishlist,
  });

  ProductModel.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    imgCover = json['imgCover'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    price = json['price'];
    priceAfterDiscount = json['priceAfterDiscount'];
    discount = json['discount'];
    rateAvg = (json['rateAvg'] as num?)?.toDouble();
    rateCount = json['rateCount'];
    sold = json['sold'];
    quantity = json['quantity'];
    category = json['category'];
    occasion = json['occasion'];
    isSuperAdmin = json['isSuperAdmin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    favoriteId = json['favoriteId'];
    isInWishlist = json['isInWishlist'];
  }
  String? id;
  String? title;
  String? slug;
  String? description;
  String? imgCover;
  List<String>? images;
  int? price;
  int? priceAfterDiscount;
  int? discount;
  double? rateAvg;
  int? rateCount;
  int? sold;
  int? quantity;
  String? category;
  String? occasion;
  bool? isSuperAdmin;
  String? createdAt;
  String? updatedAt;
  num? v;
  dynamic favoriteId;
  bool? isInWishlist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    map['slug'] = slug;
    map['description'] = description;
    map['imgCover'] = imgCover;
    map['images'] = images;
    map['price'] = price;
    map['priceAfterDiscount'] = priceAfterDiscount;
    map['discount'] = discount;
    map['rateAvg'] = rateAvg;
    map['rateCount'] = rateCount;
    map['sold'] = sold;
    map['quantity'] = quantity;
    map['category'] = category;
    map['occasion'] = occasion;
    map['isSuperAdmin'] = isSuperAdmin;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    map['favoriteId'] = favoriteId;
    map['isInWishlist'] = isInWishlist;
    return map;
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id ?? '',
      title: title ?? '',
      description: description ?? '',

      images: images ?? [],

      price: price ?? 0,

      quantity: quantity ?? 0,
    );
  }
}
