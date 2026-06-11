import 'package:flowers_app/features/address/data/data_sources/location_service.dart';
import 'package:flowers_app/features/address/data/repos/location_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'location_repo_impl_test.mocks.dart';

@GenerateMocks([LocationService])
void main() {
  late LocationRepoImpl repository;
  late MockLocationService mockLocationService;

  setUp(() {
    mockLocationService = MockLocationService();
    repository = LocationRepoImpl(mockLocationService);
  });

  const tLatLng = LatLng(30.0444, 31.2357);
  final tPlacemark = Placemark(
    administrativeArea: 'Cairo',
    locality: 'Maadi',
    street: 'Road 9',
  );

  group('Location Repository Implementation Tests', () {
    group('getCurrentLocation', () {
      test('should return LatLng when location service succeeds', () async {
        // Arrange
        when(
          mockLocationService.getCurrentLocation(),
        ).thenAnswer((_) async => tLatLng);

        // Act
        final result = await repository.getCurrentLocation();

        // Assert
        expect(result, equals(tLatLng));
        verify(mockLocationService.getCurrentLocation()).called(1);
      });

      test('should return null when location service returns null', () async {
        // Arrange
        when(
          mockLocationService.getCurrentLocation(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCurrentLocation();

        // Assert
        expect(result, isNull);
        verify(mockLocationService.getCurrentLocation()).called(1);
      });
    });

    group('getPlacemarkFromLocation', () {
      test('should return Placemark when location service succeeds', () async {
        // Arrange
        when(
          mockLocationService.getPlacemarkFromLocation(any),
        ).thenAnswer((_) async => tPlacemark);

        // Act
        final result = await repository.getPlacemarkFromLocation(tLatLng);

        // Assert
        expect(result, equals(tPlacemark));
        verify(mockLocationService.getPlacemarkFromLocation(tLatLng)).called(1);
      });

      test('should return null when location service returns null', () async {
        // Arrange
        when(
          mockLocationService.getPlacemarkFromLocation(any),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getPlacemarkFromLocation(tLatLng);

        // Assert
        expect(result, isNull);
        verify(mockLocationService.getPlacemarkFromLocation(tLatLng)).called(1);
      });
    });
  });
}
