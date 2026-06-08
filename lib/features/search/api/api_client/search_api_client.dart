import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'search_api_client.g.dart';

@injectable
@RestApi()
abstract class SearchApiClient {
  @factoryMethod
  factory SearchApiClient(Dio dio) = _SearchApiClient;

  @GET(AppEndPoints.products)
  Future<GetAllProductsResponse> searchProducts({
    @Queries() Map<String, dynamic>? queries,
  });
}
