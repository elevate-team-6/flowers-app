import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/product_details/data/models/product_details_response/product_details_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part'product_details_api_client.g.dart';
@injectable
@RestApi()
abstract class ProductDetailsApiClient {
  @factoryMethod
  factory ProductDetailsApiClient(Dio dio) => _ProductDetailsApiClient(dio);
  @GET(AppEndPoints.productDetails)
  Future<ProductDetailsResponse> getProductDetails(@Path('id') String id);
}
