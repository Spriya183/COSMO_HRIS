import 'package:attendance_system/api_services/report_api_services.dart';
import 'package:attendance_system/constant/app_color.dart';
import 'package:attendance_system/constant/color_extention.dart';
import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_date_time_converter.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/core/typography/font_style_extentions.dart';
import 'package:attendance_system/feature/report/calculate_summery.dart';
import 'package:attendance_system/feature/report/view_all_record_page.dart';
import 'package:attendance_system/model/response_model/report_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  DateTime _selectedDate = DateTime(2025, 7, 1);
  List<ReportModel> requestList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _handleReport();
  }

  Future<void> _handleReport() async {
    setState(() {
      isLoading = true;
    });

    final record = await ReportApiServices.fetchReportRecord(
      year: _selectedDate.year,
      month: _selectedDate.month,
    );

    if (record['code'] == 200) {
      final List<ReportModel> data = record['data'];
      setState(() {
        requestList = data;
        isLoading = false;
      });

      if (data.isEmpty) {
        ShowDialog(context: context).showSucessStateDialog(
          body: "No attendance data available for this month",
          title: "Empty",
        );
      }
    } else {
      setState(() {
        requestList = [];
        isLoading = false;
      });
      ShowDialog(
        context: context,
      ).showErrorStateDialog(body: record['message']);
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
      _handleReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = calculateAttendanceSummary(requestList);

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
      body: RefreshIndicator(
        onRefresh: _handleReport,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: AppPadding.basePagePadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickMonthYear(context),
                        child: Container(
                          height: 50.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff004E64)),
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
                    CustomButton(
                      backgroundColor: const Color(0xff004E64),
                      borderColor: const Color(0xff004E64),
                      textColor: Colors.white,
                      width: 90,
                      text: 'View All',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewAllRecordPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                /// Loading or Table
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                          requestList.isEmpty
                              ? const Center(
                                child: Text(
                                  "No data available for selected month.",
                                ),
                              )
                              : DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Date',
                                      style:
                                          context
                                              .textStyle(
                                                palette:
                                                    ColorPalette.sherpa_blue,
                                              )
                                              .medium,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                      style:
                                          context
                                              .textStyle(
                                                palette:
                                                    ColorPalette.sherpa_blue,
                                              )
                                              .medium,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Check In',
                                      style:
                                          context
                                              .textStyle(
                                                palette:
                                                    ColorPalette.sherpa_blue,
                                              )
                                              .medium,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Check Out',
                                      style:
                                          context
                                              .textStyle(
                                                palette:
                                                    ColorPalette.sherpa_blue,
                                              )
                                              .medium,
                                    ),
                                  ),
                                ],
                                rows:
                                    requestList.map((entry) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              formatDateOnly(
                                                entry.attendanceDate ?? '-',
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(entry.status ?? '-')),
                                          DataCell(
                                            Text(
                                              formatFullTime(
                                                entry.checkInTime ?? '-',
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              formatFullTime(
                                                entry.checkOutTime ?? '-',
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                              ),
                    ),

                SizedBox(height: 24.h),

                /// Summary Card
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Container(
                    width: double.infinity,
                    padding: AppPadding.cardPadding,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance Summary',
                          style:
                              context
                                  .textStyle(palette: ColorPalette.sherpa_blue)
                                  .header6
                                  .bold,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Total Working Days: ${summary['total']}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        Text(
                          'Present Days: ${summary['present']}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        Text(
                          'Absent Days: ${summary['absent']}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        Text(
                          'Leave Days: ${summary['leave']}',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
