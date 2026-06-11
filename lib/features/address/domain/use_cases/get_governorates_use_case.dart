import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flowers_app/features/address/domain/repositories/address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGovernoratesUseCase {
  final AddressRepoContract _repository;

  GetGovernoratesUseCase(this._repository);

  Future<BaseResponse<List<GovernorateEntity>>> call() {
    return _repository.getGovernorates();
  }
}
