import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDeliveryDate(String locale) {
    return DateFormat('dd MMM', locale).format(this);
  }

  /// وقت الوصول المتوقع بصيغة الديزاين (مثال: 03 Sep 2024, 11:00 AM).
  String formatEstimatedArrival(String locale) {
    return DateFormat('dd MMM yyyy, hh:mm a', locale).format(toLocal());
  }
}
