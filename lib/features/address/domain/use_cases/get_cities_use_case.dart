import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/repositories/address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCitiesUseCase {
  final AddressRepoContract _repository;

  GetCitiesUseCase(this._repository);

  Future<BaseResponse<List<CityEntity>>> call(String governorateId) {
    return _repository.getCities(governorateId);
  }
}
