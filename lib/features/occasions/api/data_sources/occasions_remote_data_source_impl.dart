import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/occasions/api/api_client/occasions_api_client.dart';
import 'package:flowers_app/features/occasions/data/data_sources/occasions_remote_data_source_contract.dart';
import 'package:flowers_app/features/occasions/data/models/responses/occasions_response.dart';
import 'package:flowers_app/features/occasions/data/models/responses/products_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OccasionsRemoteDataSourceContract)
class OccasionsRemoteDataSourceImpl
    implements OccasionsRemoteDataSourceContract {
  final OccasionsApiClient _apiClient;
  const OccasionsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<OccasionsResponse>> getAllOccasions() =>
      ErrorHandler.handleApiCall(() => _apiClient.getAllOccasions());

  @override
  Future<BaseResponse<ProductsResponse>> getProductsByOccasion(
    String occasionName,
  ) => ErrorHandler.handleApiCall(
    () => _apiClient.getProductsByOccasion(occasionName),
  );
}
