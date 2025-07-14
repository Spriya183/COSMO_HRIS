import 'package:attendance_system/api_services/report_api_services.dart';
import 'package:attendance_system/common/date_time_converter.dart';
import 'package:attendance_system/model/attendance_model/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:attendance_system/common/base_page.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  DateTime _selectedDate = DateTime(2025, 6, 1);
  List<reportretrive> requestList = [];
  @override
  void initState() {
    super.initState();
    _handleReport();
  }

  Future<void> _handleReport() async {
    final record = await ReportApiServices.fetchReportRecord();

    print('API response: $record');

    if (record['code'] == 200) {
      setState(() {
        requestList = record['data'];
        print('Fetched Report : ${requestList.length}');
      });
    } else {
      setState(() {
        requestList = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(record['message'] ?? 'Failed to load records')),
      );
    }
  }

  Future<void> _pickMonthYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: const Text(
        'Attendance Report',
        style: TextStyle(color: Colors.white),
      ),
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      colors: const Color(0xff004E64),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickMonthYear(context),
                    child: Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20.h,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            DateFormat('MMMM yyyy').format(_selectedDate),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
            SizedBox(height: 20.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text('Date', style: TextStyle(color: Colors.grey)),
                  ),
                  DataColumn(
                    label: Text('Status', style: TextStyle(color: Colors.grey)),
                  ),
                  DataColumn(
                    label: Text(
                      'Check In',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Check Out',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
                rows:
                    requestList.map((entry) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(formatDateOnly(entry.attendanceDate ?? '-')),
                          ),
                          DataCell(Text(entry.status ?? '-')),
                          DataCell(
                            Text(formatFullTime(entry.checkInTime ?? '-')),
                          ),
                          DataCell(
                            Text(formatFullTime(entry.checkOutTime ?? '-')),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text('Total Working Days: 3'),
                  Text(
                    'Present Days: 3',
                    style: TextStyle(color: Colors.green),
                  ),
                  Text('Absent Days: 0', style: TextStyle(color: Colors.red)),
                  Text('Leave Days: 0', style: TextStyle(color: Colors.orange)),
                  Text(
                    'Late Days: 3',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
