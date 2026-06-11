import 'package:geocoding/geocoding.dart';

extension PlacemarkExtension on Placemark {
  String formatAddress() {
    return "$street, $subLocality, $locality"
        .replaceAll(RegExp(r'^,\s*|,\s*,|,\s*$'), '')
        .trim();
  }
}
