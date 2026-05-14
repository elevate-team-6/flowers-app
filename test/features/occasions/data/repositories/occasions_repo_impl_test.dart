import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:flowers_app/features/occasions/data/data_sources/occasions_remote_data_source_contract.dart';
import 'package:flowers_app/features/occasions/data/models/responses/occasions_response.dart';
import 'package:flowers_app/features/occasions/data/models/responses/products_response.dart';
import 'package:flowers_app/features/occasions/data/models/responses/occasion_model.dart';
import 'package:flowers_app/features/occasions/data/repositories/occasions_repo_impl.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occasions_repo_impl_test.mocks.dart';

@GenerateMocks([OccasionsRemoteDataSourceContract])
void main() {
  late MockOccasionsRemoteDataSourceContract mockDataSource;
  late OccasionsRepoImpl repo;

  final fakeOccasionModel = OccasionModel(
    id: '1',
    name: 'Wedding',
    slug: 'wedding',
    image: 'image.jpg',
    productsCount: 6,
  );

  final fakeProductModel = ProductModel(
    id: '1',
    title: 'Wedding Flower',
    slug: 'wedding-flower',
    description: 'description',
    imgCover: 'https://image.png',
    images: [],
    price: 250,
    priceAfterDiscount: 100,
    discount: 60,
    rateAvg: 0,
    rateCount: 0,
    sold: 0,
    quantity: 10,
    category: 'category',
    occasion: 'occasion',
    isSuperAdmin: false,
    createdAt: '2025-01-01',
    updatedAt: '2025-01-01',
    isInWishlist: false,
  );

  final fakeOccasionsResponse = OccasionsResponse(
    message: 'success',
    occasions: [fakeOccasionModel],
  );

  final fakeProductsResponse = ProductsResponse(
    message: 'success',
    products: [fakeProductModel],
  );

  setUp(() {
    mockDataSource = MockOccasionsRemoteDataSourceContract();
    repo = OccasionsRepoImpl(mockDataSource);

    provideDummy<BaseResponse<OccasionsResponse>>(ErrorBaseResponse('dummy'));
    provideDummy<BaseResponse<ProductsResponse>>(ErrorBaseResponse('dummy'));
  });

  group('OccasionsRepoImpl', () {
    group('getAllOccasions', () {
      test('returns SuccessBaseResponse when data source succeeds', () async {
        when(
          mockDataSource.getAllOccasions(),
        ).thenAnswer((_) async => SuccessBaseResponse(fakeOccasionsResponse));

        final result = await repo.getAllOccasions();

        expect(result, isA<SuccessBaseResponse<List<OccasionEntity>>>());
        final success = result as SuccessBaseResponse<List<OccasionEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.name, 'Wedding');
      });

      test(
        'returns ErrorBaseResponse when data source returns error',
        () async {
          when(
            mockDataSource.getAllOccasions(),
          ).thenAnswer((_) async => ErrorBaseResponse('error'));

          final result = await repo.getAllOccasions();

          expect(result, isA<ErrorBaseResponse<List<OccasionEntity>>>());
          final error = result as ErrorBaseResponse<List<OccasionEntity>>;
          expect(error.errorMessage, isNotEmpty);
        },
      );
    });

    group('getProductsByOccasion', () {
      test('returns SuccessBaseResponse when data source succeeds', () async {
        when(
          mockDataSource.getProductsByOccasion('Wedding'),
        ).thenAnswer((_) async => SuccessBaseResponse(fakeProductsResponse));

        final result = await repo.getProductsByOccasion('Wedding');

        expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
        final success = result as SuccessBaseResponse<List<ProductEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.title, 'Wedding Flower');
      });

      test(
        'returns ErrorBaseResponse when data source returns error',
        () async {
          when(
            mockDataSource.getProductsByOccasion('Wedding'),
          ).thenAnswer((_) async => ErrorBaseResponse('error'));

          final result = await repo.getProductsByOccasion('Wedding');

          expect(result, isA<ErrorBaseResponse<List<ProductEntity>>>());
          final error = result as ErrorBaseResponse<List<ProductEntity>>;
          expect(error.errorMessage, isNotEmpty);
        },
      );
    });
  });
}
