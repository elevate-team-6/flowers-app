import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
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
  Future<BaseResponse<List<OccasionEntity>>> getAllOccasions() =>
      ErrorHandler.handleApiCall(() async {
        final response = await _dataSource.getAllOccasions();
        return (response.occasions ?? []).map((e) => e.toEntity()).toList();
      });
  @override
  Future<BaseResponse<List<ProductEntity>>> getProductsByOccasion(
    String occasionName,
  ) => ErrorHandler.handleApiCall(() async {
    final response = await _dataSource.getProductsByOccasion(occasionName);
    return (response.products ?? []).map((e) => e.toEntity()).toList();
  });
}
