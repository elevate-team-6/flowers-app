// ---------------------------------------------------------------------------
// TEAM INSTRUCTIONS - HOW TO ADD NEW ASSETS:
// 1. Add the asset to 'assets/icons/'.
// 2. Add the asset name to the appropriate class below.
// 3. Use lowerCamelCase for variable names.
// 4. Always use the path constants (_iconsPath).
// ---------------------------------------------------------------------------

abstract class AppIcons {
  static const String _iconsPath = 'assets/icons/';

  // Example: static const String yourIcon = '${_iconsPath}icon_name.svg';

  static const String home = '${_iconsPath}home_icon.svg';
  static const String categories = '${_iconsPath}category_icon.svg';
  static const String cart = '${_iconsPath}cart_icon.svg';
  static const String profile = '${_iconsPath}profile_icon.svg';
  static const String location = '${_iconsPath}location.png';
  static const String arrowRight = '${_iconsPath}arrow-right.png';
  static const String delete = '${_iconsPath}delete.png';
  static const String search = '${_iconsPath}search_icon.svg';
  static const String filtration = '${_iconsPath}filtration_icon.svg';
  static const String sort = '${_iconsPath}sort_icon.svg';
}

abstract class AppImages {
  static const String _imagesPath = 'assets/images/';
  static const String imageBaseUrl = 'https://flower.elevateegy.com/uploads/';
  static const String imageDefault = '${_imagesPath}Image_default.png';

  // Example: static const String yourIcon = '${_imagesPath}image_name.svg';

  static const String appImage = '${_imagesPath}app_image.svg';
  static const String defaultImage = '${_imagesPath}Image_default.png';
}

abstract class AppLottie {
  static const String _lottiePath = 'assets/lottie_files/';

  static const String flowerLoading = '${_lottiePath}flower_loading.json';
}
