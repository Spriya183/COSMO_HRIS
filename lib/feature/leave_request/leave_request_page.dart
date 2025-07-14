import 'package:attendance_system/api_services/retrive_leave_request_data_api_services.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_date_time_converter.dart';
import 'package:attendance_system/feature/leave_request/add_leave_request_page.dart';
import 'package:attendance_system/model/response_model/leave_request_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: const Text('Leave Request', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : SingleChildScrollView(
                  padding: EdgeInsets.all(25.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Request Leave Button
                      Center(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 10.r,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View and manage your leave requests',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff004E64),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 16.sp),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const NewLeaveRequestPage(),
                                    ),
                                  ).then((_) => _handleFetchLeaveRequest());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff004E64),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 14.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: const Text(
                                  'Request Leave',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 50.h),

                      Center(
                        child: Text(
                          'Leave Requests',
                          style: TextStyle(
                            color: Color(0xff004E64),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      requestList.isEmpty
                          ? const Center(
                            child: Text('No leave requests found.'),
                          )
                          : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Leave Type')),
                                DataColumn(label: Text('Start Date')),
                                DataColumn(label: Text('End Date')),
                                DataColumn(label: Text('Reason')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Requested On')),
                              ],
                              rows:
                                  requestList.map((entry) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            entry.leavePolicy?.leaveType ?? '-',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            formatDateOnly(
                                              entry.startDate ?? '',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            formatDateOnly(entry.endDate ?? ''),
                                          ),
                                        ),
                                        DataCell(Text(entry.reason ?? '-')),
                                        DataCell(
                                          Text(entry.status?.status ?? '-'),
                                        ),
                                        DataCell(
                                          Text(
                                            formatDateOnly(
                                              entry.createdAt ?? '',
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
