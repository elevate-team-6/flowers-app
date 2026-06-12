import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/address_details/data/data_sources/address_details_remote_data_source_contract.dart';
import 'package:flowers_app/features/address_details/data/models/address_model.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address_details/data/repos/address_details_repo_impl.dart';

import 'address_details_impl_test.mocks.dart';

@GenerateMocks([AddressDetailsRemoteDataSourceContract, SecureCacheHelper])
void main() {
  provideDummy<BaseResponse<AddressModel?>>(
    SuccessBaseResponse<AddressModel?>(null),
  );

  provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(null));

  late MockAddressDetailsRemoteDataSourceContract mockRemoteDataSource;
  late MockSecureCacheHelper mockCacheHelper;
  late AddressRepoDetailsImpl repository;

  const userId = 'user-id';

  setUp(() {
    mockRemoteDataSource = MockAddressDetailsRemoteDataSourceContract();
    mockCacheHelper = MockSecureCacheHelper();

    repository = AddressRepoDetailsImpl(mockRemoteDataSource, mockCacheHelper);

    when(
      mockCacheHelper.readData(key: AppKeys.userIdKey),
    ).thenAnswer((_) async => userId);
  });

  group('getDefaultAddress', () {
    test(
      'should return mapped AddressEntity when datasource returns AddressModel',
      () async {
        when(mockRemoteDataSource.getDefaultAddress(userId)).thenAnswer(
          (_) async => SuccessBaseResponse(
            AddressModel(
              id: '1',
              username: 'Youssef',
              phone: '01000000000',
              street: 'Nasr City${AppConstants.addressDelimiter}Street 10',
              city: 'Cairo',
              lat: '30.0',
              long: '31.0',
            ),
          ),
        );

        final result = await repository.getDefaultAddress();

        expect(result, isA<SuccessBaseResponse<AddressEntity?>>());

        final entity = (result as SuccessBaseResponse<AddressEntity?>).data!;

        expect(entity.id, '1');
        expect(entity.recipientName, 'Youssef');
        expect(entity.phoneNumber, '01000000000');
        expect(entity.area, 'Nasr City');
        expect(entity.street, 'Street 10');
        expect(entity.city, 'Cairo');
        expect(entity.latitude, '30.0');
        expect(entity.longitude, '31.0');
        expect(entity.isDefault, true);

        verify(mockRemoteDataSource.getDefaultAddress(userId)).called(1);
      },
    );

    test('should return null when datasource returns null address', () async {
      when(
        mockRemoteDataSource.getDefaultAddress(userId),
      ).thenAnswer((_) async => SuccessBaseResponse<AddressModel?>(null));

      final result = await repository.getDefaultAddress();

      expect(result, isA<SuccessBaseResponse<AddressEntity?>>());

      expect((result as SuccessBaseResponse<AddressEntity?>).data, isNull);

      verify(mockRemoteDataSource.getDefaultAddress(userId)).called(1);
    });

    test('should return ErrorBaseResponse when datasource fails', () async {
      when(
        mockRemoteDataSource.getDefaultAddress(userId),
      ).thenAnswer((_) async => ErrorBaseResponse('error'));

      final result = await repository.getDefaultAddress();

      expect(result, isA<ErrorBaseResponse>());

      expect((result as ErrorBaseResponse).errorMessage, 'error');

      verify(mockRemoteDataSource.getDefaultAddress(userId)).called(1);
    });
  });

  group('setDefaultAddress', () {
    test('should map entity to model and call datasource', () async {
      final entity = AddressEntity(
        id: '1',
        recipientName: 'Youssef',
        phoneNumber: '01000000000',
        street: 'Street 10',
        area: 'Nasr City',
        city: 'Cairo',
        latitude: '30.0',
        longitude: '31.0',
      );

      when(
        mockRemoteDataSource.setDefaultAddress(
          any,
          any,
          selectedByUser: anyNamed('selectedByUser'),
        ),
      ).thenAnswer((_) async => SuccessBaseResponse(null));

      await repository.setDefaultAddress( entity);

      final captured = verify(
        mockRemoteDataSource.setDefaultAddress(
          captureAny,
          captureAny,
          selectedByUser: captureAnyNamed('selectedByUser'),
        ),
      ).captured;

      expect(captured[0], userId);

      final model = captured[1] as AddressModel;

      expect(model.id, entity.id);
      expect(model.username, entity.recipientName);
      expect(model.phone, entity.phoneNumber);
      expect(model.city, entity.city);
      expect(model.lat, entity.latitude);
      expect(model.long, entity.longitude);

      expect(
        model.street,
        '${entity.area}${AppConstants.addressDelimiter}${entity.street}',
      );
    });

    test('should pass selectedByUser value correctly', () async {
      final entity = AddressEntity(
        id: '1',
        recipientName: 'Youssef',
        phoneNumber: '01000000000',
        street: 'Street 10',
        area: 'Nasr City',
        city: 'Cairo',
        latitude: '30.0',
        longitude: '31.0',
      );

      when(
        mockRemoteDataSource.setDefaultAddress(
          any,
          any,
          selectedByUser: anyNamed('selectedByUser'),
        ),
      ).thenAnswer((_) async => SuccessBaseResponse(null));

      await repository.setDefaultAddress( entity, selectedByUser: false);

      verify(
        mockRemoteDataSource.setDefaultAddress(
          userId,
          any,
          selectedByUser: false,
        ),
      ).called(1);
    });
  });
}
