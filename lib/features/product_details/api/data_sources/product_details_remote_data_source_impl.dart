import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/product_details/api/api_client/product_details_api_client.dart';
import 'package:flowers_app/features/product_details/data/data_sources/product_details_remote_data_source_contract.dart';
import 'package:flowers_app/features/product_details/data/models/product_details_response/product_details_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDetailsRemoteDataSourceContract)
class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSourceContract {
  final ProductDetailsApiClient _apiClient;
  const ProductDetailsRemoteDataSourceImpl(this._apiClient);
  @override
  Future<BaseResponse<ProductDetailsResponse>> getProductDetiles({
    required String productId,
  }) {
    return ErrorHandler.handleApiCall(() {
      return _apiClient.getProductDetails(productId);
    });
  }
}
