import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/best_seller/domain/repos/best_seller_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class BestSellerUseCase {
  final BestSellerRepoContract _bestSellerRepo;
  const BestSellerUseCase(this._bestSellerRepo);
  Future<BaseResponse<List<ProductEntity>>> call() {
    return _bestSellerRepo.bestSeller();
  }
}
 