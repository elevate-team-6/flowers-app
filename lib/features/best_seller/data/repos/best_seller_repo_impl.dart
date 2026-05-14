import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/best_seller/data/data_sources/best_seller_remote_data_sources_contract.dart';
import 'package:flowers_app/features/best_seller/data/models/best_seller_products_response/best_seller_products_response.dart';
import 'package:flowers_app/features/best_seller/domain/repos/best_saller_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BestSallerRepoContract)
class BestSellerRepoImpl implements BestSallerRepoContract {
  final BestSellerRemoteDataSourcesContract _bestSellerRemoteDataSources;

  const BestSellerRepoImpl(this._bestSellerRemoteDataSources);

  @override
  Future<BaseResponse<List<ProductEntity>>> bestSeller() async {
    final response = await _bestSellerRemoteDataSources.bestSeller();

    switch (response) {
      case SuccessBaseResponse<BestSellerProductsResponse>():
        return SuccessBaseResponse(
          response.data.bestSellerProducts?.map((e) => e.toEntity()).toList() ??
              [],
        );

      case ErrorBaseResponse<BestSellerProductsResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }
}
