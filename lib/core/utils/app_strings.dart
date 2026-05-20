import 'package:easy_localization/easy_localization.dart';

abstract class AppStrings {
  // Common & Auth
  static String get login => 'login'.tr();
  static String get signup => 'signup'.tr();
  static String get signupWithSpace => 'signupWithSpace'.tr();
  static String get password => 'password'.tr();
  static String get email => 'email'.tr();
  static String get continueText => 'continueText'.tr();
  static String get confirmPassword => 'confirmPassword'.tr();

  // Login Screen
  static String get enterYourEmail => 'enterYourEmail'.tr();
  static String get enterYourPassword => 'enterYourPassword'.tr();
  static String get rememberMe => 'rememberMe'.tr();
  static String get forgetPasswordQuestion => 'forgetPasswordQuestion'.tr();
  static String get dontHaveAccount => 'dontHaveAccount'.tr();
  static String get loginSuccess => 'loginSuccess'.tr();
  static String get forgetPasswordText => 'forgetPasswordText'.tr();

  // Sign Up Screen
  static String get userName => 'userName'.tr();
  static String get enterYourUserName => 'enterYourUserName'.tr();
  static String get firstName => 'firstName'.tr();
  static String get enterFirstName => 'enterFirstName'.tr();
  static String get lastName => 'lastName'.tr();
  static String get enterLastName => 'enterLastName'.tr();
  static String get phoneNumber => 'phoneNumber'.tr();
  static String get enterPhoneNumber => 'enterPhoneNumber'.tr();
  static String get alreadyHaveAccount => 'alreadyHaveAccount'.tr();
  static String get registerSuccess => 'registerSuccess'.tr();
  static String get signupFailedUserIsNull => 'signupFailedUserIsNull'.tr();
  static String get gender => 'gender'.tr();
  static String get female => 'female'.tr();
  static String get male => 'male'.tr();
  static String get pleaseSelectGender => 'pleaseSelectGender'.tr();
  static String get creatingAccountAgreement => 'creatingAccountAgreement'.tr();

  static String get termsAndConditions => 'termsAndConditions'.tr();
  static String get termsFooterNote => 'termsFooterNote'.tr();
  static String get iAgree => 'iAgree'.tr();

  static String get termsSection1Title => 'termsSection1Title'.tr();
  static String get termsSection1Body => 'termsSection1Body'.tr();

  static String get termsSection2Title => 'termsSection2Title'.tr();
  static String get termsSection2Body => 'termsSection2Body'.tr();

  static String get termsSection3Title => 'termsSection3Title'.tr();
  static String get termsSection3Body => 'termsSection3Body'.tr();

  static String get termsSection4Title => 'termsSection4Title'.tr();
  static String get termsSection4Body => 'termsSection4Body'.tr();

  // Forget Password Screen
  static String get forgetPasswordTitle => 'forgetPasswordTitle'.tr();
  static String get forgetPasswordSubtitle => 'forgetPasswordSubtitle'.tr();
  static String get verificationCodeSentToYourEmail =>
      'verificationCodeSentToYourEmail'.tr();
  static String get confirm => 'confirm'.tr();

  // Email Verification Screen
  static String get emailVerification => 'emailVerification'.tr();
  static String get emailVerificationSubtitle =>
      'emailVerificationSubtitle'.tr();
  static String get invalidCode => 'invalidCode'.tr();
  static String get didntReceiveCode => 'didntReceiveCode'.tr();
  static String get resend => 'resend'.tr();
  static String get verificationCodeIsCorrect =>
      'verificationCodeIsCorrect'.tr();

  // Reset Password Screen
  static String get resetPasswordTitle => 'resetPasswordTitle'.tr();
  static String get resetPasswordSubtitle => 'resetPasswordSubtitle'.tr();
  static String get newPassword => 'newPassword'.tr();
  static String get passwordResetSuccessfully =>
      'passwordResetSuccessfully'.tr();

  // Error messages
  static String get someThingWentWrong => 'someThingWentWrong'.tr();
  static String get connectionTimeout => 'connectionTimeout'.tr();
  static String get sendTimeout => 'sendTimeout'.tr();
  static String get receiveTimeout => 'receiveTimeout'.tr();
  static String get requestCancelled => 'requestCancelled'.tr();
  static String get noInternetConnection => 'noInternetConnection'.tr();
  static String get unexpectedError => 'unexpectedError'.tr();
  static String get unknownError => 'unknownError'.tr();
  static String get invalidRequest => 'invalidRequest'.tr();
  static String get authFailed => 'authFailed'.tr();
  static String get forbidden => 'forbidden'.tr();
  static String get notFound => 'notFound'.tr();
  static String get serverError => 'serverError'.tr();
  static String get defaultError => 'defaultError'.tr();
  static String get defaultErrorTryAgain => 'defaultErrorTryAgain'.tr();
  static String get unexpectedErrorTryAgain => 'unexpectedErrorTryAgain'.tr();
  static String get userAlreadyExists => 'userAlreadyExists'.tr();
  static String get invalidGender => 'invalidGender'.tr();
  static String get invalidPhoneFormat => 'invalidPhoneFormat'.tr();

  // Validation messages
  static String get emailRequired => 'emailRequired'.tr();
  static String get invalidEmail => 'invalidEmail'.tr();
  static String get invalidPassword => 'invalidPassword'.tr();
  static String get passwordRequired => 'passwordRequired'.tr();
  static String get passwordTooShort => 'passwordTooShort'.tr();
  static String get passwordLowercase => 'passwordLowercase'.tr();
  static String get passwordUppercase => 'passwordUppercase'.tr();
  static String get passwordNumber => 'passwordNumber'.tr();
  static String get passwordSpecialCharacter => 'passwordSpecialCharacter'.tr();
  static String get passwordNotMatched => 'passwordNotMatched'.tr();
  static String get confirmPasswordRequired => 'confirmPasswordRequired'.tr();
  static String get usernameRequired => 'usernameRequired'.tr();
  static String get usernameTooShort => 'usernameTooShort'.tr();
  static String get usernameInvalid => 'usernameInvalid'.tr();
  static String get firstNameRequired => 'firstNameRequired'.tr();
  static String get lastNameRequired => 'lastNameRequired'.tr();
  static String get nameTooShort => 'nameTooShort'.tr();
  static String get nameNoNumbers => 'nameNoNumbers'.tr();
  static String get phoneRequired => 'phoneRequired'.tr();
  static String get invalidPhone => 'invalidPhone'.tr();
  static String get phoneMustStartWithCountryCode =>
      'phoneMustStartWithCountryCode'.tr();

  // Main Layout
  static String get home => 'home'.tr();
  static String get categories => 'categories'.tr();
  static String get cart => 'cart'.tr();
  static String get profile => 'profile'.tr();

  // Occasions
  static String get noProductsFound => 'noProductsFound'.tr();
  static String get addToCart => 'addToCart'.tr();
  static String get occasion => 'occasion'.tr();
  static String get occasionSubtitle => 'occasionSubtitle'.tr();
  static String get egp => 'egp'.tr();
  //home
  static String get flowery => 'flowery'.tr();
  static String get search => 'search'.tr();
  static String get deliverToMockAddress => 'deliverToMockAddress'.tr();
  static String get icon => 'icon'.tr();
  static String get label => 'label'.tr();
  static String get bestSeller => 'bestSeller'.tr();
  static String get image => 'image'.tr();
  static String get title => 'title'.tr();
  static String get price => 'price'.tr();
  static String get viewAll => 'viewAll'.tr();
  static String get noBestSellersAvailable => 'noBestSellersAvailable'.tr();
  static String get bestSellers => 'bestSellers'.tr();
  static String get noCategoriesAvailable => 'noCategoriesAvailable'.tr();
  static String get deliverTo => 'deliverTo'.tr();
  static String get noOccasionsAvailable => 'noOccasionsAvailable'.tr();
  //Best Seller
  static String get retry => 'retry'.tr();
  static String get subTitleBestSeller => 'subTitleBestSeller'.tr();
}
