import 'package:flowers_app/features/occasions/data/models/responses/occasions_response.dart';
import 'package:flowers_app/features/occasions/data/models/responses/products_response.dart';

abstract interface class OccasionsRemoteDataSourceContract {
  Future<OccasionsResponse> getAllOccasions();
  Future<ProductsResponse> getProductsByOccasion(String occasionName);
}
