import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flowers_app/features/cart/domain/repos/cart_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearCartUseCase {
  final CartRepoContract _repo;
  const ClearCartUseCase(this._repo);

  Future<BaseResponse<CartEntity>> call() => _repo.clearCart();
}
