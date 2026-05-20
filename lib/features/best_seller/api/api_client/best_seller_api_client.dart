import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../data/models/best_seller_products_response/best_seller_products_response.dart';
part 'best_seller_api_client.g.dart';

@injectable
@RestApi()
abstract class BestSellerApiClient {
  @factoryMethod
  factory BestSellerApiClient(Dio dio) => _BestSellerApiClient(dio);
  @GET(AppEndPoints.bestSeller)
  Future<BestSellerProductsResponse> bestSeller();
}
