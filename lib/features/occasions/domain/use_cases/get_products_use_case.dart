import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/occasions/domain/entities/product_entity.dart';
import 'package:flowers_app/features/occasions/domain/repositories/occasions_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsUseCase {
  final OccasionsRepoContract _repo;
  const GetProductsUseCase(this._repo);

  Future<BaseResponse<List<ProductEntity>>> call(String occasionName) =>
      _repo.getProductsByOccasion(occasionName);
}
