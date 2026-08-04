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
  static const String ordersCollection = 'orders';
  static const String defaultAddressCollection = 'default_address';
  static const String defaultAddressDocId = 'current';
  static const String firestoreIdField = 'id';
  static const String fcmTokenField = 'fcmToken';
  static const String lastLoginField = 'lastLogin';
  static const String orderIdField = 'orderId';
  static const String orderNumberField = 'orderNumber';
  static const String statusField = 'status';
  static const String riderIdField = 'riderId';
  static const String riderNameField = 'riderName';
  static const String riderPhoneField = 'riderPhone';
  static const String riderLocationField = 'riderLocation';
  static const String userIdField = 'userId';
  static const String shippingAddressField = 'shippingAddress';
  static const String streetField = 'street';
  static const String phoneField = 'phone';
  static const String cityField = 'city';
  static const String latField = 'lat';
  static const String longField = 'long';
  static const String createdAtField = 'createdAt';
  static const String isUserConfirmedDeliverdField = 'isUserConfirmedDeliverd';
  static const String languageField = 'language';
  static const String notificationsField = 'notifications';
  static const String notificationTitleField = 'title';
  static const String notificationBodyField = 'body';
  static const String notificationSentTimeField = 'sentTime';
  static const String notificationDataField = 'data';
  static const String notificationsBox = 'notifications_box';
  static const String lastOpenedNotificationsTimeKey =
      'last_opened_notifications_time';
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
  // موقع الستور (نقطة انطلاق المسار الثابت على الخريطة لحد ما يتضاف موقع الرايدر الحي)
  static const double storeLatitude = 30.0626;
  static const double storeLongitude = 31.2497;
  static const double defaultMapZoom = 14.0;
  static const String mapUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapUserAgent = 'com.example.flowers_app';

  // مدة التوصيل التقديرية الثابتة — بنزوّدها على createdAt عشان نحسب وقت الوصول
  // المتوقع لحد ما الباك إند يوفّر وقت حقيقي.
  static const int estimatedDeliveryMinutes = 45;
}
