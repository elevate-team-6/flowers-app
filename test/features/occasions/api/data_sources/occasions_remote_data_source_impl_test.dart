import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/occasions/api/api_client/occasions_api_client.dart';
import 'package:flowers_app/features/occasions/api/data_sources/occasions_remote_data_source_impl.dart';
import 'package:flowers_app/features/occasions/data/models/responses/occasions_response.dart';
import 'package:flowers_app/features/occasions/data/models/responses/products_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'occasions_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OccasionsApiClient])
void main() {
  late MockOccasionsApiClient mockApiClient;
  late OccasionsRemoteDataSourceImpl dataSource;

  final fakeOccasionsResponse = OccasionsResponse(
    message: 'success',
    occasions: [],
  );

  final fakeProductsResponse = ProductsResponse(
    message: 'success',
    products: [],
  );

  setUp(() {
    mockApiClient = MockOccasionsApiClient();
    dataSource = OccasionsRemoteDataSourceImpl(mockApiClient);

    provideDummy<OccasionsResponse>(fakeOccasionsResponse);
    provideDummy<ProductsResponse>(fakeProductsResponse);
  });

  group('OccasionsRemoteDataSourceImpl', () {
    group('getAllOccasions', () {
      test('returns SuccessBaseResponse when api call succeeds', () async {
        when(
          mockApiClient.getAllOccasions(),
        ).thenAnswer((_) async => fakeOccasionsResponse);

        final result = await dataSource.getAllOccasions();

        expect(result, isA<SuccessBaseResponse<OccasionsResponse>>());
        final success = result as SuccessBaseResponse<OccasionsResponse>;
        expect(success.data.message, 'success');
      });

      test(
        'returns ErrorBaseResponse when api call throws DioException',
        () async {
          when(mockApiClient.getAllOccasions()).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionError,
            ),
          );

          final result = await dataSource.getAllOccasions();

          expect(result, isA<ErrorBaseResponse<OccasionsResponse>>());
          final error = result as ErrorBaseResponse<OccasionsResponse>;
          expect(error.errorMessage, isNotEmpty);
        },
      );

      test(
        'returns ErrorBaseResponse when api call throws generic exception',
        () async {
          when(
            mockApiClient.getAllOccasions(),
          ).thenThrow(Exception('unexpected error'));

          final result = await dataSource.getAllOccasions();

          expect(result, isA<ErrorBaseResponse<OccasionsResponse>>());
          final error = result as ErrorBaseResponse<OccasionsResponse>;
          expect(error.errorMessage, isNotEmpty);
        },
      );
    });

    group('getProductsByOccasion', () {
      test('returns SuccessBaseResponse when api call succeeds', () async {
        when(
          mockApiClient.getProductsByOccasion('Wedding'),
        ).thenAnswer((_) async => fakeProductsResponse);

        final result = await dataSource.getProductsByOccasion('Wedding');

        expect(result, isA<SuccessBaseResponse<ProductsResponse>>());
        final success = result as SuccessBaseResponse<ProductsResponse>;
        expect(success.data.message, 'success');
      });

      test(
        'returns ErrorBaseResponse when api call throws DioException',
        () async {
          when(mockApiClient.getProductsByOccasion('Wedding')).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionError,
            ),
          );

          final result = await dataSource.getProductsByOccasion('Wedding');

          expect(result, isA<ErrorBaseResponse<ProductsResponse>>());
          final error = result as ErrorBaseResponse<ProductsResponse>;
          expect(error.errorMessage, isNotEmpty);
        },
      );

      test(
        'returns ErrorBaseResponse when api call throws generic exception',
        () async {
          when(
            mockApiClient.getProductsByOccasion('Wedding'),
          ).thenThrow(Exception('unexpected error'));

          final result = await dataSource.getProductsByOccasion('Wedding');

          expect(result, isA<ErrorBaseResponse<ProductsResponse>>());
          final error = result as ErrorBaseResponse<ProductsResponse>;
          expect(error.errorMessage, isNotEmpty);
        },
      );
    });
  });
}
