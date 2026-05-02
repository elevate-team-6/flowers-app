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

  // Forget Password Screen
  static const String forgetPassword = 'Forget password';
  static const String forgetPasswordSubtitle =
      'Please enter your email associated to your account';

  // Email Verification Screen
  static const String emailVerification = 'Email verification';
  static const String emailVerificationSubtitle =
      'Please enter your code that sent to your email address';
  static const String invalidCode = 'Invalid code';
  static const String didntReceiveCode = "Didn't receive code? ";
  static const String resend = 'Resend';

  // Reset Password Screen
  static const String resetPassword = 'Reset password';
  static const String resetPasswordSubtitle =
      'Password must not be empty and must contain 6 characters with upper case letter and one number at least';
  static const String newPassword = 'New password';
  static const String passwordResetSuccessfully = "Password reset successfully";

  // Error messages
  static const String someThingWentWrong = 'Something went wrong';

  // Validation messages
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Enter a valid email address';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordLowercase =
      'Password must contain at least one lowercase letter';
  static const String passwordUppercase =
      'Password must contain at least one uppercase letter';
  static const String passwordNumber =
      'Password must contain at least one number';
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
}
