import 'package:flowers_app/core/utils/app_strings.dart';

abstract class AppValidations {
  AppValidations._();

  // ── Generic ──
  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  // ── Name ──
  static String? validateUserName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.usernameRequired;
    }
    if (value.length < 3) {
      return AppStrings.usernameTooShort;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return AppStrings.usernameInvalid;
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.firstNameRequired;
    }
    if (value.trim().length < 3) {
      return AppStrings.nameTooShort;
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return AppStrings.nameNoNumbers;
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.lastNameRequired;
    }
    if (value.trim().length < 3) {
      return AppStrings.nameTooShort;
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return AppStrings.nameNoNumbers;
    }
    return null;
  }

  // ── Email ──
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  // ── Password ──
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return AppStrings.passwordLowercase;
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.passwordUppercase;
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.passwordNumber;
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.passwordSpecialCharacter;
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }
    if (value != password) {
      return AppStrings.passwordNotMatched;
    }
    return null;
  }

  // ── Phone ──
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequired;
    }
    if (value.length < 11) {
      return AppStrings.invalidPhone;
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(cleaned)) {
      return AppStrings.invalidPhone;
    }
    return null;
  }
}
