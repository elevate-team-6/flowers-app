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
  Future<OccasionsResponse> getAllOccasions() => _apiClient.getAllOccasions();

  @override
  Future<ProductsResponse> getProductsByOccasion(String occasionName) =>
      _apiClient.getProductsByOccasion(occasionName);
}
