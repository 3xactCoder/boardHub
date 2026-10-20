/// Просте форматування дат без сторонніх пакетів (intl).
abstract final class DateFormatter {
  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// «Thursday, September 24, 2026»
  static String fullDate(DateTime date) =>
      '${_weekdays[date.weekday - 1]}, ${longDate(date)}';

  /// «September 24, 2026»
  static String longDate(DateTime date) =>
      '${_months[date.month - 1]} ${date.day}, ${date.year}';

  static String greeting(DateTime date) {
    if (date.hour < 12) return 'Good morning';
    if (date.hour < 18) return 'Good afternoon';
    return 'Good evening';
  }
}
