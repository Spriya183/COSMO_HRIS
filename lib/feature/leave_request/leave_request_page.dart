import 'package:attendance_system/api_services/retrive_leave_request_data_api_services.dart';
import 'package:attendance_system/constant/app_color.dart';
import 'package:attendance_system/constant/color_extention.dart';
import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_date_time_converter.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/core/typography/font_style_extentions.dart';
import 'package:attendance_system/feature/leave_request/add_leave_request_page.dart';
import 'package:attendance_system/feature/leave_request/leave_request_table_page.dart';
import 'package:attendance_system/model/request_model/leave_request_model.dart';

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

      ShowDialog(context: context).showErrorStateDialog(body: errorMessage);
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
                : RefreshIndicator(
                  onRefresh: _handleFetchLeaveRequest,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppPadding.basePagePadding,
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
                                  offset: const Offset(0, 4),
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
                                    color: const Color(0xff004E64),
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

                        SizedBox(height: 20.h),

                        /// Table or List View of Leave Requests
                        LeaveRequestTablePage(), // This widget should ideally take the refreshed `requestList` if needed
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
