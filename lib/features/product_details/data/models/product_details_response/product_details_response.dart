import 'package:flowers_app/config/models/product_model/product_model.dart';

class ProductDetailsResponse {
  ProductDetailsResponse({
      this.message, 
      this.product,});

  ProductDetailsResponse.fromJson(dynamic json) {
    message = json['message'];
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }
  String? message;
  ProductModel? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }

}

