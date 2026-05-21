import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flowers_app/features/cart/domain/repos/cart_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCartUseCase {
  final CartRepoContract _repo;
  const GetCartUseCase(this._repo);

  Future<BaseResponse<CartEntity>> call() => _repo.getCart();
}
