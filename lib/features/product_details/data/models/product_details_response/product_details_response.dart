import 'package:flowers_app/features/product_details/data/models/product_details_response/product_details_model.dart';

class ProductDetailsResponse {
  ProductDetailsResponse({this.message, this.product});

  ProductDetailsResponse.fromJson(dynamic json) {
    message = json['message'];
    product = json['product'] != null
        ? ProductDetailsModel.fromJson(json['product'])
        : null;
  }
  String? message;
  ProductDetailsModel? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (product != null) {
      map['product'] = product?.toEntity();
    }
    return map;
  }
}
