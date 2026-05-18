abstract class AppStrings {
  // Common & Auth
  static const String login = 'Login';
  static const String signup = 'Signup';
  static const String signupWithSpace = 'Sign up';
  static const String password = 'Password';
  static const String email = 'Email';
  static const String continueText = 'Continue';
  static const String confirmPassword = 'Confirm password';

  // Login Screen
  static const String enterYourEmail = 'Enter your email';
  static const String enterYourPassword = 'Enter your password';
  static const String rememberMe = 'Remember me';
  static const String forgetPasswordQuestion = 'Forget password?';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String loginSuccess = 'Login success';
  static const String forgetPasswordText = 'Forget password?';

  // Sign Up Screen
  static const String userName = 'User name';
  static const String enterYourUserName = 'Enter your user name';
  static const String firstName = 'First name';
  static const String enterFirstName = 'Enter first name';
  static const String lastName = 'Last name';
  static const String enterLastName = 'Enter last name';
  static const String phoneNumber = 'Phone number';
  static const String enterPhoneNumber = 'Enter phone number';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String registerSuccess = 'Register success';
  static const String signupFailedUserIsNull = 'Signup failed: user is null';

  static const String termsAndConditions = 'Terms & Conditions';
  static const String termsFooterNote =
      'By tapping "I Agree", you confirm that you have read and understood these Terms & Conditions.';
  static const String iAgree = 'I Agree';

  static const String termsSection1Title = 'Acceptance of Terms';
  static const String termsSection1Body =
      'By creating an account and using Flowers App, you agree to be bound by these Terms and Conditions. If you do not agree, please do not use our services.';

  static const String termsSection2Title = 'Privacy Policy';
  static const String termsSection2Body =
      'We collect and use your personal data as described in our Privacy Policy. Your data is stored securely and will not be shared with third parties without your consent.';

  static const String termsSection3Title = 'User Responsibilities';
  static const String termsSection3Body =
      'You are responsible for maintaining the confidentiality of your account credentials. You agree not to share your account with others or use it for unauthorized purposes.';

  static const String termsSection4Title = 'Changes to Terms';
  static const String termsSection4Body =
      'We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes your acceptance of the new terms.';

  // Forget Password Screen
  static const String forgetPasswordTitle = 'Forget password';
  static const String forgetPasswordSubtitle =
      'Please enter your email associated to your account';
  static const String verificationCodeSentToYourEmail =
      'Verification code sent to your email';
  static const String confirm = '"Confirm"';

  // Email Verification Screen
  static const String emailVerification = 'Email verification';
  static const String emailVerificationSubtitle =
      'Please enter your code that sent to your email address';
  static const String invalidCode = 'Invalid code';
  static const String didntReceiveCode = "Didn't receive code? ";
  static const String resend = 'Resend';
  static const String verificationCodeIsCorrect =
      'verification code is correct';

  // Reset Password Screen
  static const String resetPasswordTitle = 'Reset password';
  static const String resetPasswordSubtitle =
      'Password must not be empty and must contain 6 characters with upper case letter and one number at least';
  static const String newPassword = 'New password';
  static const String passwordResetSuccessfully = "Password reset successfully";

  // Error messages
  static const String someThingWentWrong = 'Something went wrong';
  static const String connectionTimeout =
      "Connection timed out. Please check your internet and try again.";
  static const String sendTimeout =
      "Request timed out while sending data. Please try again.";
  static const String receiveTimeout =
      "Server took too long to respond. Please try again.";
  static const String requestCancelled = "The request was cancelled.";
  static const String noInternetConnection =
      "No internet connection. Please check your network.";
  static const String unexpectedError =
      "An unexpected error occurred. Please try again later.";
  static const String unknownError =
      "An unknown error occurred. Please try again.";
  static const String invalidRequest =
      "Invalid request. Please check your input.";
  static const String authFailed =
      "Authentication failed. Please log in again.";
  static const String forbidden =
      "You don't have permission to perform this action.";
  static const String notFound = "The requested resource was not found.";
  static const String serverError =
      "Our servers are currently experiencing issues. Please try again later.";
  static const String defaultError = "Oops! Something went wrong.";
  static const String defaultErrorTryAgain =
      "Oops! Something went wrong. Please try again.";
  static const String unexpectedErrorTryAgain =
      "An unexpected error occurred. Please try again.";
  static const String userAlreadyExists =
      'This account already exists. Please try logging in or use a different email/phone.';
  static const String invalidGender = 'Please select a valid gender.';
  static const String invalidPhoneFormat =
      'Invalid phone number format. Please check and try again.';

  // Validation messages
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Enter a valid email address';
  static const String invalidPassword = 'Invalid password';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordLowercase =
      'Password must contain at least one lowercase letter';
  static const String passwordUppercase =
      'Password must contain at least one uppercase letter';
  static const String passwordNumber =
      'Password must contain at least one number';
  static const String passwordSpecialCharacter =
      'Password must contain at least 1 special character';
  static const String passwordNotMatched = 'Password not matched';
  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String usernameRequired = 'Username is required';
  static const String usernameTooShort =
      'Username must be at least 3 characters';
  static const String usernameInvalid =
      'Only letters, numbers and underscore allowed';
  static const String firstNameRequired = 'First name is required';
  static const String lastNameRequired = 'Last name is required';
  static const String nameTooShort = 'Must be at least 3 characters';
  static const String nameNoNumbers = 'Name must not contain numbers';
  static const String phoneRequired = 'Phone number is required';
  static const String invalidPhone = 'Enter a valid phone number';
  static const String phoneMustStartWithCountryCode =
      'Phone must start with country code (e.g. +20)';

  // Main Layout
  static const String home = 'Home';
  static const String categories = 'Categories';
  static const String cart = 'Cart';
  static const String profile = 'Profile';

  // Occasions
  static const String noProductsFound = 'No products found';
  static const String addToCart = 'Add to cart';
  static const String occasion = 'Occasion';
  static const String occasionSubtitle =
      'Bloom with our exquisite best sellers';
  static const String egp = 'EGP';
}
