import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/best_seller_products_response/best_seller_products_response.dart';
part 'best_seller_api_client.g.dart';

@injectable
@RestApi()
abstract class BestSellerApiClient {
  @factoryMethod
  factory BestSellerApiClient(Dio dio) = _BestSellerApiClient;
  @GET(AppEndPoints.bestSeller)
  @Extra({AppKeys.cacheDurationHours: 5})
  Future<BestSellerProductsResponse> bestSeller();
}
