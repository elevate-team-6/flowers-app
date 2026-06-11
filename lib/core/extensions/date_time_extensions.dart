extension DateTimeExtensions on DateTime {
  /// يحوّل التاريخ لصيغة مختصرة زي "5Jan 2026"
  String toShortDate() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '$day${months[month - 1]} $year';
  }
}
