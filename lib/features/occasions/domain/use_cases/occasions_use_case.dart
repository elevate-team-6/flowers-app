import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/repositories/occasions_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class OccasionsUseCase {
  final OccasionsRepoContract _repo;
  const OccasionsUseCase(this._repo);

  Future<BaseResponse<List<OccasionEntity>>> call() => _repo.getAllOccasions();
}
