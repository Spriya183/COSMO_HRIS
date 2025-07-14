import 'package:attendance_system/core/common/custom_date_time_converter.dart';
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

  Future<void> loadRecords() async {
    final result = await AttendanceRecordApiServices.fetchAttendanceRecords();

    if (result['status']) {
      setState(() {
        attendanceList = result['data'] ?? [];
      });
    } else {
      setState(() {
        attendanceList = [];
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
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Text(
            'Attendance Table',
            style: TextStyle(color: Colors.black, fontSize: 20.sp),
          ),
          SizedBox(height: 10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Text('Date', style: TextStyle(color: Colors.grey)),
                ),
                DataColumn(
                  label: Text('Check In', style: TextStyle(color: Colors.grey)),
                ),
                DataColumn(
                  label: Text(
                    'Check Out',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                DataColumn(
                  label: Text('Status', style: TextStyle(color: Colors.grey)),
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
                        DataCell(Text(formatFullTime(dataMap['checkInTime']))),
                        DataCell(Text(formatFullTime(dataMap['checkOutTime']))),
                        DataCell(Text(dataMap['status'] ?? '')),
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
