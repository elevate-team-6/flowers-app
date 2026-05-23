import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';

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
      return AppStrings.usernameRequired.tr();
    }
    if (value.length < 3) {
      return AppStrings.usernameTooShort.tr();
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return AppStrings.usernameInvalid.tr();
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.firstNameRequired.tr();
    }
    if (value.trim().length < 3) {
      return AppStrings.nameTooShort.tr();
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return AppStrings.nameNoNumbers.tr();
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.lastNameRequired.tr();
    }
    if (value.trim().length < 3) {
      return AppStrings.nameTooShort.tr();
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return AppStrings.nameNoNumbers.tr();
    }
    return null;
  }

  // ── Email ──
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired.tr();
    }
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail.tr();
    }
    return null;
  }

  // ── Password ──
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired.tr();
    }

    if (value.length < 8) {
      return AppStrings.passwordTooShort.tr();
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return AppStrings.passwordLowercase.tr();
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.passwordUppercase.tr();
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.passwordNumber.tr();
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.passwordSpecialCharacter.tr();
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired.tr();
    }
    if (value != password) {
      return AppStrings.passwordNotMatched.tr();
    }
    return null;
  }

  // ── Phone ──
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequired.tr();
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!cleaned.startsWith('+')) {
      return AppStrings.phoneMustStartWithCountryCode.tr();
    }
    if (!RegExp(r'^\+[0-9]{10,15}$').hasMatch(cleaned)) {
      return AppStrings.invalidPhone.tr();
    }
    return null;
  }
}
