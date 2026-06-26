abstract class AppConstants {
  static const String translationsPath = 'assets/translations';
  static const String arabicCode = 'ar';
  static const String englishCode = 'en';
  static const String lowestPrice = 'lowestPrice';
  static const String highestPrice = 'highestPrice';
  static const String newText = 'new';
  static const String oldText = 'old';
  static const String discountText = 'discount';
  static const String checkoutUrlQuery = 'url';
  static const String checkoutRedirectUrl = 'http://localhost:3000';
  static const String cash = 'cash';
  static const String card = 'card';

  // Address Feature Constants
  static const String usersCollection = 'users';
  static const String addressesCollection = 'addresses';
  static const String defaultAddressCollection = 'default_address';
  static const String defaultAddressDocId = 'current';
  static const String firestoreIdField = '_id';
  static const String notificationsField = 'notifications';
  static const String notificationTitleField = 'title';
  static const String notificationBodyField = 'body';
  static const String notificationSentTimeField = 'sentTime';
  static const String notificationDataField = 'data';
  static const String addressDelimiter = " | ";
  static const String governoratesJsonPath = 'assets/json/governorates.json';
  static const String citiesJsonPath = 'assets/json/cities.json';
  static const String jsonNameKey = 'name';
  static const String jsonDataKey = 'data';
  static const String governoratesKey = 'governorates';
  static const String citiesKey = 'cities';

  // Map Constants
  static const double defaultLatitude = 30.0444;
  static const double defaultLongitude = 31.2357;
  static const double defaultMapZoom = 14.0;
  static const String mapUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapUserAgent = 'com.example.flowers_app';
}
