import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/entities/product_entity.dart';
import 'package:flowers_app/features/product_details/data/data_sources/product_details_remote_data_source_contract.dart';
import 'package:flowers_app/features/product_details/data/models/product_details_response/product_details_response.dart';
import 'package:flowers_app/features/product_details/domain/repos/product_details_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDetailsRepoContract)
class ProductDetailsRepoImpl implements ProductDetailsRepoContract {
  final ProductDetailsRemoteDataSourceContract _productDetailsRemoteDataSource;
  const ProductDetailsRepoImpl(this._productDetailsRemoteDataSource);
  @override
  Future<BaseResponse<ProductEntity>> getProductDetiles({
    required String productId,
  }) async {
    final response = await _productDetailsRemoteDataSource.getProductDetiles(
      productId: productId,
    );
    switch (response) {
      case SuccessBaseResponse<ProductDetailsResponse>():
        return SuccessBaseResponse(response.data.product!.toEntity());
      case ErrorBaseResponse<ProductDetailsResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }
}
