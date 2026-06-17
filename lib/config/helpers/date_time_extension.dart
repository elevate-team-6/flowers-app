import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDeliveryDate(String locale) {
    return DateFormat('dd MMM', locale).format(this);
  }
}
