abstract class AppEndPoints {
  // Base URL:
  static const String baseUrl = "https://flower.elevateegy.com/api/v1";

  // API EndPoints:-

  // Auth:
  static const String signup = "$baseUrl/auth/signup";
  static const String signin = "$baseUrl/auth/signin";
  static const String forgetPassword = "$baseUrl/auth/forgotPassword";
  static const String verifyResetCode = "$baseUrl/auth/verifyResetCode";
  static const String resetPassword = "$baseUrl/auth/resetPassword";
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String logout = "$baseUrl/auth/logout";
  static const String profileData = "$baseUrl/auth/profile-Data";
  static const String editProfile = "$baseUrl/auth/editProfile";
  static const String uploadPhoto = "$baseUrl/auth/upload-photo";

  // Web Views:
  static const String termsAndConditionsUrl =
      "https://elevate-flutter-team.github.io/flower_app_web_views/terms.html";
  static const String aboutUsUrl =
      "https://elevate-flutter-team.github.io/flower_app_web_views/about.html";

  //ocasions:
  static const String occasions = "$baseUrl/occasions";

  // Home:
  static const String bestSeller = "$baseUrl/best-seller";

  // Categories:
  static const String categories = "$baseUrl/categories";

  // Products:
  static const String products = "$baseUrl/products";
  static const String productDetails = "$baseUrl/products/{id}";

  // cart:
  static const String cart = '$baseUrl/cart';
  static const String cartProductPath = '$cart/{productId}';
  static const String productIdParam = 'productId';
  static const String addresses = "$baseUrl/addresses";

  //checkout
  static const String cashCheckout = "$baseUrl/orders";
  static const String cardCheckout = '$cashCheckout/checkout';
  // orders:
  static const String orders = '$baseUrl/orders';
  // Addresses:
  static const String addressIdParam = "id";
  static const String addressPath = "$addresses/{$addressIdParam}";
  // ---------------------------------------------------------------------------
  // TO ADD NEW ENDPOINTS:
  // 1. Group them by feature (e.g., // Products, // Cart).
  // 2. Use 'static const String' with camelCase naming.
  // 3. Always prefix the path with '$baseUrl'.
  // Example: static const String getProducts = "$baseUrl/products";
  // ---------------------------------------------------------------------------
}
