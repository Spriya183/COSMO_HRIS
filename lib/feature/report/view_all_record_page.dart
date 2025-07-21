import 'package:attendance_system/api_services/attendance_record_api_services.dart';
import 'package:attendance_system/constant/app_color.dart';
import 'package:attendance_system/constant/color_extention.dart';
import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_date_time_converter.dart';
import 'package:attendance_system/core/typography/font_style_extentions.dart';
import 'package:attendance_system/model/response_model/attendance_table_model.dart';
import 'package:flutter/material.dart';

class ViewAllRecordPage extends StatefulWidget {
  const ViewAllRecordPage({super.key});

  @override
  State<ViewAllRecordPage> createState() => _ViewAllRecordPageState();
}

class _ViewAllRecordPageState extends State<ViewAllRecordPage> {
  List<AttendanceRecords> attendanceList = [];
  bool isLoading = false;

  Future<void> loadRecords() async {
    setState(() {
      isLoading = true;
    });

    final result = await AttendanceRecordApiServices.fetchAttendanceRecords();

    if (result['status']) {
      setState(() {
        attendanceList = result['data'] ?? [];
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
    return BasePage(
      title: const Text(
        'View All Record',
        style: TextStyle(color: Colors.white),
      ),
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      colors: const Color(0xff004E64),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: loadRecords,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppPadding.basePagePadding,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            'Date',
                            style:
                                context
                                    .textStyle(
                                      palette: ColorPalette.sherpa_blue,
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
                                      palette: ColorPalette.sherpa_blue,
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
                                      palette: ColorPalette.sherpa_blue,
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
                                      palette: ColorPalette.sherpa_blue,
                                    )
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
                                  Text(
                                    formatDateOnly(dataMap['attendanceDate']),
                                  ),
                                ),
                                DataCell(
                                  Text(formatFullTime(dataMap['checkInTime'])),
                                ),
                                DataCell(
                                  Text(formatFullTime(dataMap['checkOutTime'])),
                                ),
                                DataCell(Text(dataMap['status'] ?? '')),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
    );
  }
}
