import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/occasions/data/models/responses/occasions_response.dart';
import 'package:flowers_app/features/occasions/data/models/responses/products_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'occasions_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class OccasionsApiClient {
  @factoryMethod
  factory OccasionsApiClient(Dio dio) = _OccasionsApiClient;

  @GET(AppEndPoints.occasions)
  Future<OccasionsResponse> getAllOccasions();

  @GET(AppEndPoints.products)
  Future<ProductsResponse> getProductsByOccasion(
    @Query('keyword') String occasionName,
  );
}
