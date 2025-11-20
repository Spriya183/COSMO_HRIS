import 'package:attendance_system/api_services/employee_status_api_services.dart';
import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/feature/attendance/attendance_request_page.dart';
import 'package:attendance_system/feature/attendance/checkinpage.dart';
import 'package:attendance_system/feature/attendance/checkoutpage.dart';
import 'package:attendance_system/feature/common/attendance_page_container.dart';
import 'package:attendance_system/feature/common/menubar_drawer.dart';
import 'package:attendance_system/feature/common/attendance_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Attentancepage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(bool) onDrawerChanged;

  const Attentancepage({
    super.key,
    required this.scaffoldKey,
    required this.onDrawerChanged,
  });

  @override
  State<Attentancepage> createState() => _HomepageState();
}

class _HomepageState extends State<Attentancepage> {
  String? status;
  final GlobalKey<AttendanceTableState> tableKey =
      GlobalKey<AttendanceTableState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    setState(() => isLoading = true);
    await fetchonlyStatus();
    await tableKey.currentState?.loadRecords();
    setState(() => isLoading = false);
  }

  Future<void> fetchonlyStatus() async {
    final statusResponse = await EmployeeStatusApiServices.fetchStatusRecords();
    if (statusResponse != null && statusResponse.Data != null) {
      setState(() => status = statusResponse.Data!.status);
    }
  }

  Future<void> _handleRefresh() async {
    await Future.wait([
      fetchonlyStatus(),
      tableKey.currentState?.loadRecords() ?? Future.value(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scaffoldKey: widget.scaffoldKey,
      onDrawerChanged: widget.onDrawerChanged,
      title: const Text('Attendance', style: TextStyle(color: Colors.white)),
      showBackButton: false,
      centerTitle: true,
      drawer: const MenubarDrawer(),
      leadingWidget: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppPadding.basePagePadding,
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AttendancePageContainer(
                      title: 'Check In',
                      titlecolor: Colors.black,
                      borderColor: Colors.grey,
                      backgroundColor:
                          (status == 'Present' || status == 'Leave')
                              ? Colors.blueGrey
                              : Colors.cyan,
                      icon: Icons.login,
                      onPressed:
                          (status == 'Present' || status == 'Leave')
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CheckInScreen(),
                                  ),
                                );
                              },
                      buttonTextColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: AttendancePageContainer(
                      title: 'Check Out',
                      titlecolor: Colors.black,
                      borderColor: Colors.grey,
                      backgroundColor: Colors.red.shade400,
                      icon: Icons.logout,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckOutScreen(),
                          ),
                        );
                      },
                      buttonTextColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              AttendancePageContainer(
                title: 'Attendance Request',
                titlecolor: Colors.black,
                borderColor: Colors.grey,
                backgroundColor: Colors.cyan,
                icon: Icons.add_alert_outlined,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestAttendancePage(),
                    ),
                  );
                },
                buttonTextColor: Colors.white,
              ),
              SizedBox(height: 10.h),
              AttendanceTable(key: tableKey),
            ],
          ),
        ),
      ),
    );
  }
}
