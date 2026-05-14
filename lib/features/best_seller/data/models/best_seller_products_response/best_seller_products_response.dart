import 'package:flowers_app/core/models/product_model.dart';

class BestSellerProductsResponse {
  final String? message;
  final List<ProductModel>? bestSellerProducts;

  BestSellerProductsResponse({this.message, this.bestSellerProducts});

  factory BestSellerProductsResponse.fromJson(Map<String, dynamic> json) {
    return BestSellerProductsResponse(
      message: json['message'],
      bestSellerProducts: (json['bestSeller'] as List?)
          ?.map((e) => ProductModel.fromJson(e))
          .toList(),
    );
  }
}
