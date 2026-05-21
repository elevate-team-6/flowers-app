import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:flowers_app/features/best_seller/data/data_sources/best_seller_remote_data_sources_contract.dart';
import 'package:flowers_app/features/best_seller/data/models/best_seller_products_response/best_seller_products_response.dart';
import 'package:flowers_app/features/best_seller/data/repos/best_seller_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'best_seller_repo_impl_test.mocks.dart';

@GenerateMocks([BestSellerRemoteDataSourceContract])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<BestSellerProductsResponse>>(
      SuccessBaseResponse<BestSellerProductsResponse>(
        BestSellerProductsResponse(bestSellerProducts: []),
      ),
    );
  });
  late MockBestSellerRemoteDataSourceContract mockRemoteDataSource;

  late BestSellerRepoImpl repoImpl;

  setUp(() {
    mockRemoteDataSource = MockBestSellerRemoteDataSourceContract();

    repoImpl = BestSellerRepoImpl(mockRemoteDataSource);
  });

  group('Best Seller Repo Impl Tests', () {
    final productModel = ProductModel(
      id: '1',
      title: 'Rose',
      description: 'desc',
      imgCover: 'img',
      images: const [],
      price: 100,
      priceAfterDiscount: 80,
      discount: 20,
      rateAvg: 0,
      rateCount: 0,
      sold: 0,
      quantity: 0,
      category: '1',
      occasion: '1',
      favoriteId: null,
    );

    final productEntity = ProductEntity(
      id: '1',
      title: 'Rose',
      imgCover: 'img',
      price: 100,
      priceAfterDiscount: 80,
      discount: 20,
      description: 'desc',
    );

    test('should return success response with products list', () async {
      when(mockRemoteDataSource.bestSeller()).thenAnswer(
        (_) async => SuccessBaseResponse<BestSellerProductsResponse>(
          BestSellerProductsResponse(bestSellerProducts: [productModel]),
        ),
      );

      final result = await repoImpl.bestSeller();

      expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());

      expect((result as SuccessBaseResponse<List<ProductEntity>>).data, [
        productEntity,
      ]);

      verify(mockRemoteDataSource.bestSeller()).called(1);
    });

    test('should return error response', () async {
      when(mockRemoteDataSource.bestSeller()).thenAnswer(
        (_) async => ErrorBaseResponse<BestSellerProductsResponse>('Error'),
      );

      final result = await repoImpl.bestSeller();

      expect(result, isA<ErrorBaseResponse<List<ProductEntity>>>());

      expect(
        (result as ErrorBaseResponse<List<ProductEntity>>).errorMessage,
        'Error',
      );

      verify(mockRemoteDataSource.bestSeller()).called(1);
    });
  });
}
