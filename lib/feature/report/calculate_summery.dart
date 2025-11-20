import 'package:intl/intl.dart';
import 'package:attendance_system/model/response_model/report_model.dart';

Map<String, int> calculateAttendanceSummary(List<ReportModel> list) {
  int total = list.length;
  int present = 0;
  int absent = 0;
  int leave = 0;

  for (var entry in list) {
    final status = entry.status?.toLowerCase();
    if (status == 'present') present++;
    if (status == 'absent') absent++;
    if (status == 'leave') leave++;

    if (status == 'present' && entry.checkInTime != null) {
      try {
        final time = DateFormat("HH:mm:ss").parse(entry.checkInTime!);
        if (time.isAfter(DateTime(time.year, time.month, time.day, 10, 0))) {}
      } catch (e) {
        // If time format is invalid or null
        continue;
      }
    }
  }

  return {'total': total, 'present': present, 'absent': absent, 'leave': leave};
}
