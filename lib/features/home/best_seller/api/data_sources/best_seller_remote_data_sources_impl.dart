import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/home/best_seller/api/api_client/best_seller_api_client.dart';
import 'package:flowers_app/features/home/best_seller/data/data_sources/best_seller_remote_data_sources_contract.dart';
import 'package:flowers_app/features/home/best_seller/data/models/best_seller_products_response/best_seller_products_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BestSellerRemoteDataSourcesContract)
class BestSellerRemoteDataSourcesImpl
    implements BestSellerRemoteDataSourcesContract {
  final BestSellerApiClient _bestSellerApiClient;
  const BestSellerRemoteDataSourcesImpl(this._bestSellerApiClient);

  @override
  Future<BaseResponse<BestSellerProductsResponse>> bestSeller() {
    return ErrorHandler.handleApiCall(() {
      return _bestSellerApiClient.bestSeller();
    });
  }
}
