import 'package:attendance_system/api_services/retrive_leave_request_data_api_services.dart';
import 'package:attendance_system/constant/app_color.dart';
import 'package:attendance_system/constant/color_extention.dart';
import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_date_time_converter.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/core/typography/font_style_extentions.dart';
import 'package:attendance_system/model/request_model/leave_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestTablePage extends StatefulWidget {
  const LeaveRequestTablePage({super.key});

  @override
  State<LeaveRequestTablePage> createState() => _LeaveRequestTablePageState();
}

class _LeaveRequestTablePageState extends State<LeaveRequestTablePage> {
  List<retriveLeaveRequestData> requestList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _handleFetchLeaveRequest();
  }

  Future<void> _handleFetchLeaveRequest() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final record =
        await RetriveLeaveRequestDataApiServices.fetchLeaveRequestRecords();

    print('API response: $record');

    if (record['code'] == 200) {
      setState(() {
        requestList = record['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        requestList = [];
        isLoading = false;
        errorMessage = record['message'] ?? 'Failed to load records';
      });

      ShowDialog(context: context).showErrorStateDialog(body: errorMessage);
    }
  }

  String displayText(String? value) {
    return (value != null && value.trim().isNotEmpty) ? value : '-';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      // Request Leave Title
                      Padding(
                        padding: AppPadding.cardPadding,
                        child: Text(
                          'Leave Requests',
                          style:
                              context
                                  .textStyle(palette: ColorPalette.sherpa_blue)
                                  .header6
                                  .bold,
                        ),
                      ),
                      // Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                'Leave Type',
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
                                'Start Date',
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
                                'End Date',
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
                                'Reason',
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
                            DataColumn(
                              label: Text(
                                'Requested On',
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
                              requestList.isEmpty
                                  ? [
                                    const DataRow(
                                      cells: [
                                        DataCell(Text('-')),
                                        DataCell(Text('-')),
                                        DataCell(Text('-')),
                                        DataCell(Text('-')),
                                        DataCell(Text('-')),
                                        DataCell(Text('-')),
                                      ],
                                    ),
                                  ]
                                  : requestList.map((entry) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            displayText(
                                              entry.leavePolicy?.leaveType,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            displayText(
                                              entry.startDate != null
                                                  ? formatDateOnly(
                                                    entry.startDate!,
                                                  )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            displayText(
                                              entry.endDate != null
                                                  ? formatDateOnly(
                                                    entry.endDate!,
                                                  )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(displayText(entry.reason)),
                                        ),
                                        DataCell(
                                          Text(
                                            displayText(entry.status?.status),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            displayText(
                                              entry.createdAt != null
                                                  ? formatDateOnly(
                                                    entry.createdAt!,
                                                  )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
