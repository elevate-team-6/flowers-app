import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/entities/product_entity.dart';

abstract interface class OccasionsRepoContract {
  Future<BaseResponse<List<OccasionEntity>>> getAllOccasions();
  Future<BaseResponse<List<ProductEntity>>> getProductsByOccasion(
    String occasionName,
  );
}
