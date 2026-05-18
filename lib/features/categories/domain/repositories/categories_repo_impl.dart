import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/categories/api/data_sources/categories_remote_data_source_contract.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_categories_response.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/categories/data/repositories/categories_repo_contract.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/entities/product_entity.dart';

@Injectable(as: CategoriesRepoContract)
class CategoriesRepoImpl implements CategoriesRepoContract {
  final CategoriesRemoteDataSourceContract _remoteDataSource;

  // لاحظ هنا شيلنا الـ LocalDataSource خالص
  CategoriesRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<CategoriesEntity>> getCategories() async {
    final response = await _remoteDataSource.getCategories();
    switch (response) {
      case SuccessBaseResponse<GetAllCategoriesResponse>():
        // الكاش بيحصل دلوقتي أوتوماتيك جوه الـ Dio
        return SuccessBaseResponse<CategoriesEntity>(response.data.toEntity());
      case ErrorBaseResponse<GetAllCategoriesResponse>():
        return ErrorBaseResponse<CategoriesEntity>(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<List<ProductEntity>>> getProducts(
    GetProductsParams params,
  ) async {
    final response = await _remoteDataSource.getProducts(params);
    switch (response) {
      case SuccessBaseResponse<GetAllProductsResponse>():
        return SuccessBaseResponse<List<ProductEntity>>(
          response.data.products!.map((e) => e.toEntity()).toList(),
        );
      case ErrorBaseResponse<GetAllProductsResponse>():
        return ErrorBaseResponse<List<ProductEntity>>(response.errorMessage);
    }
  }
}
