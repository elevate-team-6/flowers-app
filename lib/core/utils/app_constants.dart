abstract class AppConstants {
  static const String translationsPath = 'assets/translations';
  static const String arabicCode = 'ar';
  static const String englishCode = 'en';
  static const String lowestPrice = 'lowestPrice';
  static const String highestPrice = 'highestPrice';
  static const String newText = 'new';
  static const String oldText = 'old';
  static const String discountText = 'discount';

  // Address Feature Constants
  static const String usersCollection = 'users';
  static const String addressesCollection = 'addresses';
  static const String defaultAddressCollection = 'default_address';
  static const String defaultAddressDocId = 'current';
  static const String firestoreIdField = '_id';
  static const String addressDelimiter = " | ";
  static const String governoratesJsonPath = 'assets/json/governorates.json';
  static const String citiesJsonPath = 'assets/json/cities.json';

  // Map Constants
  static const double defaultLatitude = 30.0444;
  static const double defaultLongitude = 31.2357;
  static const double defaultMapZoom = 14.0;
  static const String mapUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapUserAgent = 'com.example.flowers_app';
}
