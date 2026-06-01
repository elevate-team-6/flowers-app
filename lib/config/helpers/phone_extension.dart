extension PhoneExtension on String {
  String toEgyptianPhone() {
    final cleaned = trim();

    if (cleaned.startsWith('+2')) {
      return cleaned;
    }

    return '+2$cleaned';
  }

  String toLocalEgyptianPhone() {
    final cleaned = trim();

    if (cleaned.startsWith('+20')) {
      return '0${cleaned.substring(3)}';
    }

    return cleaned;
  }
}
