import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/product_details/data/data_sources/product_details_remote_data_source_contract.dart';
import 'package:flowers_app/features/product_details/data/models/product_details_response/product_details_model.dart';
import 'package:flowers_app/features/product_details/data/models/product_details_response/product_details_response.dart';
import 'package:flowers_app/features/product_details/data/repos/product_details_repo_impl.dart';
import 'package:flowers_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_details_repo_impl_test.mocks.dart';

@GenerateMocks([ProductDetailsRemoteDataSourceContract])
void main() {
  late MockProductDetailsRemoteDataSourceContract mockRemoteDataSource;

  late ProductDetailsRepoImpl repoImpl;

  setUpAll(() {
    provideDummy<BaseResponse<ProductDetailsResponse>>(
      SuccessBaseResponse(
        ProductDetailsResponse(
          product: ProductDetailsModel(
            id: '',
            title: '',
            description: '',
            images: [],
            price: 0,
            quantity: 0,
          ),
        ),
      ),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockProductDetailsRemoteDataSourceContract();

    repoImpl = ProductDetailsRepoImpl(mockRemoteDataSource);
  });

  group('ProductDetailsRepoImpl', () {
    final productModel = ProductDetailsModel(
      id: '1',
      title: 'Flower',
      description: 'desc',
      images: ['image'],
      price: 100,
      quantity: 10,
    );

    final productEntity = ProductDetailsEntity(
      title: 'Flower',
      description: 'desc',
      images: ['image'],
      price: 100,
      quantity: 10,
      imgCover: '',
    );

    final responseModel = ProductDetailsResponse(product: productModel);

    test(
      'should return SuccessBaseResponse<ProductDetailsEntity> when api call success',
      () async {
        when(
          mockRemoteDataSource.getProductDetiles(productId: '1'),
        ).thenAnswer((_) async => SuccessBaseResponse(responseModel));

        final result = await repoImpl.getProductDetiles(productId: '1');

        expect(result, isA<SuccessBaseResponse<ProductDetailsEntity>>());

        final successResult =
            result as SuccessBaseResponse<ProductDetailsEntity>;

        expect(successResult.data, productEntity);

        verify(
          mockRemoteDataSource.getProductDetiles(productId: '1'),
        ).called(1);
      },
    );

    test('should return ErrorBaseResponse when api call fails', () async {
      when(
        mockRemoteDataSource.getProductDetiles(productId: '1'),
      ).thenAnswer((_) async => ErrorBaseResponse('error'));

      final result = await repoImpl.getProductDetiles(productId: '1');

      expect(result, isA<ErrorBaseResponse<ProductDetailsEntity>>());

      final errorResult = result as ErrorBaseResponse<ProductDetailsEntity>;

      expect(errorResult.errorMessage, 'error');

      verify(mockRemoteDataSource.getProductDetiles(productId: '1')).called(1);
    });
  });
}