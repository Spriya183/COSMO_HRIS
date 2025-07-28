import 'package:attendance_system/constant/app_color.dart';
import 'package:attendance_system/constant/color_extention.dart';
import 'package:attendance_system/core/common/custom_date_time_converter.dart';
import 'package:attendance_system/core/typography/font_style_extentions.dart';
import 'package:attendance_system/model/response_model/attendance_table_model.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/api_services/attendance_record_api_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceTable extends StatefulWidget {
  const AttendanceTable({super.key});

  @override
  State<AttendanceTable> createState() => AttendanceTableState();
}

class AttendanceTableState extends State<AttendanceTable> {
  List<AttendanceRecords> attendanceList = [];
  bool isLoading = false;

  Future<void> loadRecords() async {
    setState(() {
      isLoading = true;
    });

    final result = await AttendanceRecordApiServices.fetchAttendanceRecords();

    if (result['status']) {
      final List<AttendanceRecords> allRecords = result['data'] ?? [];

      final DateTime now = DateTime.now();
      final int currentYear = now.year;
      final int currentMonth = now.month;

      final List<AttendanceRecords> filteredRecords =
          allRecords.where((record) {
            final String? dateStr = record.attendanceDate;
            if (dateStr == null || dateStr.isEmpty) return false;

            try {
              final date = DateTime.parse(dateStr).toLocal();
              return date.year == currentYear && date.month == currentMonth;
            } catch (_) {
              return false;
            }
          }).toList();

      setState(() {
        attendanceList = filteredRecords;
        isLoading = false;
      });
    } else {
      setState(() {
        attendanceList = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to load records')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                'Attendance Record',
                style:
                    context
                        .textStyle(palette: ColorPalette.sherpa_blue)
                        .header6
                        .bold,
              ),
              SizedBox(height: 10.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'Date',
                        style:
                            context
                                .textStyle(palette: ColorPalette.sherpa_blue)
                                .medium,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Check In',
                        style:
                            context
                                .textStyle(palette: ColorPalette.sherpa_blue)
                                .medium,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Check Out',
                        style:
                            context
                                .textStyle(palette: ColorPalette.sherpa_blue)
                                .medium,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style:
                            context
                                .textStyle(palette: ColorPalette.sherpa_blue)
                                .medium,
                      ),
                    ),
                  ],
                  rows:
                      attendanceList.map((entry) {
                        final dataMap = entry.toJson();
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(formatDateOnly(dataMap['attendanceDate'])),
                            ),
                            DataCell(
                              Text(formatFullTime(dataMap['checkInTime'])),
                            ),
                            DataCell(
                              Text(formatFullTime(dataMap['checkOutTime'])),
                            ),
                            DataCell(Text(dataMap['status'] ?? '-')),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
  }
}
