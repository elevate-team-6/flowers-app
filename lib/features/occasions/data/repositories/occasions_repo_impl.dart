import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/occasions/data/data_sources/occasions_remote_data_source_contract.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/entities/product_entity.dart';
import 'package:flowers_app/features/occasions/domain/repositories/occasions_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OccasionsRepoContract)
class OccasionsRepoImpl implements OccasionsRepoContract {
  final OccasionsRemoteDataSourceContract _dataSource;
  const OccasionsRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<List<OccasionEntity>>> getAllOccasions() async {
    final result = await _dataSource.getAllOccasions();
    switch (result) {
      case SuccessBaseResponse():
        return SuccessBaseResponse(
          (result.data.occasions ?? []).map((e) => e.toEntity()).toList(),
        );
      case ErrorBaseResponse():
        return ErrorBaseResponse(result.errorMessage);
    }
  }

  @override
  Future<BaseResponse<List<ProductEntity>>> getProductsByOccasion(
    String occasionName,
  ) async {
    final result = await _dataSource.getProductsByOccasion(occasionName);
    switch (result) {
      case SuccessBaseResponse():
        return SuccessBaseResponse(
          (result.data.products ?? []).map((e) => e.toEntity()).toList(),
        );
      case ErrorBaseResponse():
        return ErrorBaseResponse(result.errorMessage);
    }
  }
}
