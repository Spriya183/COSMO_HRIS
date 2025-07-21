import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/feature/attendance/attendance_request_page.dart';
import 'package:attendance_system/feature/common/attendance_page_container.dart';
import 'package:attendance_system/feature/common/menubar_drawer.dart';
import 'package:attendance_system/feature/common/attendance_table.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:flutter/material.dart';

import 'package:attendance_system/api_services/checkin_api_services.dart';
import 'package:attendance_system/api_services/checkout_api_services.dart';

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
  final GlobalKey<AttendanceTableState> tableKey =
      GlobalKey<AttendanceTableState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleCheckIn() async {
    final result = await CheckinApiServices.checkinRecord();
    ShowDialog(context: context).showSucessStateDialog(body: result['message']);
    tableKey.currentState?.loadRecords();
  }

  Future<void> _handleCheckout() async {
    final result = await CheckoutApiServices.checkoutRecord();
    ShowDialog(context: context).showSucessStateDialog(body: result['message']);
    tableKey.currentState?.loadRecords();
  }

  Future<void> _handleRefresh() async {
    // Reload the attendance table
    tableKey.currentState?.loadRecords();
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
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
                              backgroundColor: Colors.cyan,
                              icon: Icons.login,
                              onPressed: _handleCheckout,
                              buttonTextColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: AttendancePageContainer(
                              title: 'Check Out',
                              titlecolor: Colors.black,
                              borderColor: Colors.grey,
                              backgroundColor: Colors.red.shade400,
                              icon: Icons.logout,
                              onPressed: _handleCheckout,
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
