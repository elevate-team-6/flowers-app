import 'dart:convert';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/address/api/data_sources/address_local_data_source_impl.dart';
import 'package:flowers_app/features/address/data/models/city_model.dart';
import 'package:flowers_app/features/address/data/models/governorate_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AddressLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = AddressLocalDataSourceImpl();
  });

  const String tGovJson = '''
  [
    {
      "name": "governorates",
      "data": [
        {"id": "1", "governorate_name_ar": "القاهرة", "governorate_name_en": "Cairo"}
      ]
    }
  ]
  ''';

  const String tCityJson = '''
  [
    {
      "name": "cities",
      "data": [
        {"id": "1", "governorate_id": "1", "city_name_ar": "المعادي", "city_name_en": "Maadi"},
        {"id": "2", "governorate_id": "2", "city_name_ar": "الرمل", "city_name_en": "Ramleh"}
      ]
    }
  ]
  ''';

  group('AddressLocalDataSourceImpl', () {
    test(
      'getGovernorates: parses JSON correctly and returns SuccessBaseResponse',
      () async {
        // Mock rootBundle
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (message) async {
              final Uint8List encoded = utf8.encoder.convert(tGovJson);
              return encoded.buffer.asByteData();
            });

        final result = await dataSource.getGovernorates();

        expect(result, isA<SuccessBaseResponse<List<GovernorateModel>>>());
        final data =
            (result as SuccessBaseResponse<List<GovernorateModel>>).data;
        expect(data.length, 1);
        expect(data[0].nameEn, 'Cairo');
      },
    );

    test(
      'getCities: filters cities by governorateId and returns SuccessBaseResponse',
      () async {
        // Mock rootBundle
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (message) async {
              final Uint8List encoded = utf8.encoder.convert(tCityJson);
              return encoded.buffer.asByteData();
            });

        // Fetch cities for gov ID "1"
        final result = await dataSource.getCities('1');

        expect(result, isA<SuccessBaseResponse<List<CityModel>>>());
        final data = (result as SuccessBaseResponse<List<CityModel>>).data;
        expect(data.length, 1);
        expect(data[0].nameEn, 'Maadi');
        expect(data[0].governorateId, '1');
      },
    );

    test(
      'error handling: returns ErrorBaseResponse when JSON is invalid',
      () async {
        // Evict from cache to ensure our mock is used
        rootBundle.evict(AppConstants.governoratesJsonPath);

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (message) async {
              final Uint8List encoded = utf8.encoder.convert('invalid json');
              return encoded.buffer.asByteData();
            });

        final result = await dataSource.getGovernorates();

        expect(result, isA<ErrorBaseResponse>());
      },
    );
  });
}
