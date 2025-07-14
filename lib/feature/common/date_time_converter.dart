/// Format time as HH:MM:SS (24-hour)
String formatFullTime(String? dateTimeStr) {
  if (dateTimeStr == null || dateTimeStr.isEmpty) return '-';
  try {
    final time = DateTime.parse(dateTimeStr).toLocal();
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  } catch (e) {
    return '-';
  }
}

/// Format date as YYYY-MM-DD
String formatDateOnly(String? dateTimeStr) {
  if (dateTimeStr == null || dateTimeStr.isEmpty) return '-';
  try {
    final date = DateTime.parse(dateTimeStr).toLocal();
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  } catch (e) {
    return '-';
  }
}
