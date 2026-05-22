abstract class AppStrings {
  // ===========================================================================
  // Configuration Keys (Keys used in JSON files)
  // ===========================================================================

  // Common & Auth
  static const String login = 'login';
  static const String signup = 'signup';
  static const String signupWithSpace = 'signupWithSpace';
  static const String password = 'password';
  static const String email = 'email';
  static const String continueText = 'continueText';
  static const String confirmPassword = 'confirmPassword';

  // Login Screen
  static const String enterYourEmail = 'enterYourEmail';
  static const String enterYourPassword = 'enterYourPassword';
  static const String rememberMe = 'rememberMe';
  static const String forgetPasswordQuestion = 'forgetPasswordQuestion';
  static const String dontHaveAccount = 'dontHaveAccount';
  static const String loginSuccess = 'loginSuccess';
  static const String forgetPasswordText = 'forgetPasswordText';

  // Sign Up Screen
  static const String userName = 'userName';
  static const String enterYourUserName = 'enterYourUserName';
  static const String firstName = 'firstName';
  static const String enterFirstName = 'enterFirstName';
  static const String lastName = 'lastName';
  static const String enterLastName = 'enterLastName';
  static const String phoneNumber = 'phoneNumber';
  static const String enterPhoneNumber = 'enterPhoneNumber';
  static const String alreadyHaveAccount = 'alreadyHaveAccount';
  static const String registerSuccess = 'registerSuccess';
  static const String signupFailedUserIsNull = 'signupFailedUserIsNull';
  static const String gender = 'gender';
  static const String female = 'female';
  static const String male = 'male';
  static const String pleaseSelectGender = 'pleaseSelectGender';
  static const String creatingAccountAgreement = 'creatingAccountAgreement';
  static const String iAgree = 'iAgree';

  // Terms & Conditions
  static const String termsAndConditions = 'termsAndConditions';
  static const String termsFooterNote = 'termsFooterNote';
  static const String termsSection1Title = 'termsSection1Title';
  static const String termsSection1Body = 'termsSection1Body';
  static const String termsSection2Title = 'termsSection2Title';
  static const String termsSection2Body = 'termsSection2Body';
  static const String termsSection3Title = 'termsSection3Title';
  static const String termsSection3Body = 'termsSection3Body';
  static const String termsSection4Title = 'termsSection4Title';
  static const String termsSection4Body = 'termsSection4Body';

  // Forget Password Screen
  static const String forgetPasswordTitle = 'forgetPasswordTitle';
  static const String forgetPasswordSubtitle = 'forgetPasswordSubtitle';
  static const String verificationCodeSentToYourEmail =
      'verificationCodeSentToYourEmail';
  static const String confirm = 'confirm';

  // Email Verification Screen
  static const String emailVerification = 'emailVerification';
  static const String emailVerificationSubtitle = 'emailVerificationSubtitle';
  static const String invalidCode = 'invalidCode';
  static const String didntReceiveCode = 'didntReceiveCode';
  static const String resend = 'resend';
  static const String verificationCodeIsCorrect = 'verificationCodeIsCorrect';

  // Reset Password Screen
  static const String resetPasswordTitle = 'resetPasswordTitle';
  static const String resetPasswordSubtitle = 'resetPasswordSubtitle';
  static const String newPassword = 'newPassword';
  static const String passwordResetSuccessfully = 'passwordResetSuccessfully';

  // Main Layout & Home
  static const String home = 'home';
  static const String categories = 'categories';
  static const String cart = 'cart';
  static const String profile = 'profile';
  static const String flowery = 'flowery';
  static const String search = 'search';
  static const String deliverTo = 'deliverTo';
  static const String deliverToMockAddress = 'deliverToMockAddress';
  static const String bestSellers = 'bestSellers';
  static const String bestSeller = 'bestSeller';
  static const String viewAll = 'viewAll';
  static const String retry = 'retry';
  static const String subTitleBestSeller = 'subTitleBestSeller';

  // Placeholder/Generic
  static const String noProductsFound = 'noProductsFound';
  static const String noBestSellersAvailable = 'noBestSellersAvailable';
  static const String noCategoriesAvailable = 'noCategoriesAvailable';
  static const String noOccasionsAvailable = 'noOccasionsAvailable';
  static const String addToCart = 'addToCart';
  static const String occasion = 'occasion';
  static const String occasionSubtitle = 'occasionSubtitle';
  static const String egp = 'egp';
  static const String icon = 'icon';
  static const String label = 'label';
  static const String image = 'image';
  static const String title = 'title';
  static const String price = 'price';

  // Error Messages
  static const String someThingWentWrong = 'someThingWentWrong';
  static const String connectionTimeout = 'connectionTimeout';
  static const String sendTimeout = 'sendTimeout';
  static const String receiveTimeout = 'receiveTimeout';
  static const String requestCancelled = 'requestCancelled';
  static const String noInternetConnection = 'noInternetConnection';
  static const String unexpectedError = 'unexpectedError';
  static const String unknownError = 'unknownError';
  static const String invalidRequest = 'invalidRequest';
  static const String authFailed = 'authFailed';
  static const String forbidden = 'forbidden';
  static const String notFound = 'notFound';
  static const String serverError = 'serverError';
  static const String defaultError = 'defaultError';
  static const String defaultErrorTryAgain = 'defaultErrorTryAgain';
  static const String unexpectedErrorTryAgain = 'unexpectedErrorTryAgain';
  static const String userAlreadyExists = 'userAlreadyExists';
  static const String invalidGender = 'invalidGender';
  static const String invalidPhoneFormat = 'invalidPhoneFormat';

  // Validation Messages
  static const String emailRequired = 'emailRequired';
  static const String invalidEmail = 'invalidEmail';
  static const String invalidPassword = 'invalidPassword';
  static const String passwordRequired = 'passwordRequired';
  static const String passwordTooShort = 'passwordTooShort';
  static const String passwordLowercase = 'passwordLowercase';
  static const String passwordUppercase = 'passwordUppercase';
  static const String passwordNumber = 'passwordNumber';
  static const String passwordSpecialCharacter = 'passwordSpecialCharacter';
  static const String passwordNotMatched = 'passwordNotMatched';
  static const String confirmPasswordRequired = 'confirmPasswordRequired';
  static const String usernameRequired = 'usernameRequired';
  static const String usernameTooShort = 'usernameTooShort';
  static const String usernameInvalid = 'usernameInvalid';
  static const String firstNameRequired = 'firstNameRequired';
  static const String lastNameRequired = 'lastNameRequired';
  static const String nameTooShort = 'nameTooShort';
  static const String nameNoNumbers = 'nameNoNumbers';
  static const String phoneRequired = 'phoneRequired';
  static const String invalidPhone = 'invalidPhone';
  static const String phoneMustStartWithCountryCode =
      'phoneMustStartWithCountryCode';

  // ===========================================================================
  // API Constants (Values sent directly to Backend - Do NOT Translate)
  // ===========================================================================
  static const String femaleValue = 'female';
  static const String maleValue = 'male';
}
