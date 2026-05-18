import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flowers_app/features/cart/domain/repos/cart_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveItemUseCase {
  final CartRepoContract _repo;
  const RemoveItemUseCase(this._repo);

  Future<BaseResponse<CartEntity>> call(String productId) =>
      _repo.removeItem(productId);
}
