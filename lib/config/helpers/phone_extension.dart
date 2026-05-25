extension PhoneExtension on String {
  String toEgyptianPhone() {
    final cleaned = trim();

    if (cleaned.startsWith('+2')) {
      return cleaned;
    }

    return '+2$cleaned';
  }
}
