import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/occasions/data/models/responses/occasions_response.dart';
import 'package:flowers_app/features/occasions/data/models/responses/products_response.dart';

abstract interface class OccasionsRemoteDataSourceContract {
  Future<BaseResponse<OccasionsResponse>> getAllOccasions();
  Future<BaseResponse<ProductsResponse>> getProductsByOccasion(
    String occasionName,
  );
}
