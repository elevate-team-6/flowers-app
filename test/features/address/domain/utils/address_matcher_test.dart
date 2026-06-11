import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flowers_app/features/address/domain/utils/address_matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  late AddressMatcher matcher;

  final tGovernorates = [
    const GovernorateEntity(id: '1', nameEn: 'Cairo', nameAr: 'القاهرة'),
    const GovernorateEntity(id: '2', nameEn: 'Giza', nameAr: 'الجيزة'),
  ];

  final tCities = [
    const CityEntity(
      id: '10',
      governorateId: '1',
      nameEn: 'Maadi',
      nameAr: 'المعادي',
    ),
    const CityEntity(
      id: '11',
      governorateId: '1',
      nameEn: 'Nasr City',
      nameAr: 'مدينة نصر',
    ),
  ];

  setUp(() {
    matcher = AddressMatcher();
  });

  group('AddressMatcher Tests', () {
    group('matchGovernorate', () {
      test('should return correct ID when name matches English name', () {
        final result = matcher.matchGovernorate(
          tGovernorates,
          'Cairo Governorate',
        );
        expect(result, '1');
      });

      test('should return correct ID when name matches Arabic name', () {
        final result = matcher.matchGovernorate(tGovernorates, 'القاهرة');
        expect(result, '1');
      });

      test('should return null when name does not match', () {
        final result = matcher.matchGovernorate(tGovernorates, 'Alexandria');
        expect(result, isNull);
      });

      test('should return null when name is null', () {
        final result = matcher.matchGovernorate(tGovernorates, null);
        expect(result, isNull);
      });
    });

    group('matchCity', () {
      test(
        'should return correct ID when Placemark locality matches English name',
        () {
          final place = Placemark(locality: 'Maadi');
          final result = matcher.matchCity(tCities, place);
          expect(result, '10');
        },
      );

      test(
        'should return correct ID when Placemark subAdministrativeArea matches',
        () {
          final place = Placemark(subAdministrativeArea: 'Nasr City');
          final result = matcher.matchCity(tCities, place);
          expect(result, '11');
        },
      );

      test('should return null when no fields match any city', () {
        final place = Placemark(locality: 'Unknown');
        final result = matcher.matchCity(tCities, place);
        expect(result, isNull);
      });
    });

    group('matchCityByName', () {
      test(
        'should return correct ID when English name matches exactly (case-insensitive)',
        () {
          final result = matcher.matchCityByName(tCities, 'maadi');
          expect(result, '10');
        },
      );

      test('should return correct ID when Arabic name matches exactly', () {
        final result = matcher.matchCityByName(tCities, 'المعادي');
        expect(result, '10');
      });

      test('should return null when name does not match any city', () {
        final result = matcher.matchCityByName(tCities, 'Dokki');
        expect(result, isNull);
      });
    });
  });
}
