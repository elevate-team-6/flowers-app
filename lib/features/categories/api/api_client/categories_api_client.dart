import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_categories_response.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'categories_api_client.g.dart';

@injectable
@RestApi()
abstract class CategoriesApiClient {
  @factoryMethod
  factory CategoriesApiClient(Dio dio) = _CategoriesApiClient;

  @GET(AppEndPoints.categories)
  @Extra({'cache_duration_hours': 24}) // كاش للأقسام ليوم كامل
  Future<GetAllCategoriesResponse> getCategories();

  @GET(AppEndPoints.products)
  @Extra({'cache_duration_hours': 1}) // كاش للمنتجات لمدة ساعة
  Future<GetAllProductsResponse> getProducts({
    @Queries() Map<String, dynamic>? queries,
  });
}
