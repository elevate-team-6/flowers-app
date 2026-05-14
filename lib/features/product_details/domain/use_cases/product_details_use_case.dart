import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flowers_app/features/product_details/domain/repos/product_details_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsUseCase {
  final ProductDetailsRepoContract _productDetailsRepo;
  const ProductDetailsUseCase(this._productDetailsRepo);
  Future<BaseResponse<ProductDetailsEntity>> call(String productId) {
    return _productDetailsRepo.getProductDetiles(productId: productId);
  }
}
