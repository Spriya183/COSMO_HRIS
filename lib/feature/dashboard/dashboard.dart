import 'dart:ui';

import 'package:attendance_system/api_services/employee_authentication_api_services.dart';
import 'package:attendance_system/api_services/employee_status_api_services.dart';
import 'package:attendance_system/constant/app_color.dart';
import 'package:attendance_system/constant/app_font_size.dart';
import 'package:attendance_system/constant/color_extention.dart';
import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_date_time_converter.dart';
import 'package:attendance_system/core/typography/font_style_extentions.dart';
import 'package:attendance_system/feature/common/menubar_drawer.dart';
import 'package:attendance_system/feature/leave_request/leave_request_table_page.dart';
import 'package:attendance_system/service/api_url.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(bool) onDrawerChanged;

  const Dashboard({
    super.key,
    required this.scaffoldKey,
    required this.onDrawerChanged,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? fullName;
  String? department;
  String? position;
  int? employeeId;
  String? email;
  String? status;
  String? checkInTime;
  String? checkOutTime;
  String? imageUrl;

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    await Future.wait([fetchEmployee(), fetchStatus()]);
    setState(() => isLoading = false);
  }

  Future<void> fetchEmployee() async {
    final authResponse =
        await EmployeeAuthenticationApiServices.authenticateEmployee();

    if (authResponse != null && authResponse.data != null) {
      setState(() {
        fullName = authResponse.data!.fullName;
        department = authResponse.data!.department;
        position = authResponse.data!.position;
        employeeId = authResponse.data!.id;
        email = authResponse.data!.email;
        imageUrl = authResponse.data!.imageUrl ?? '';
        errorMessage = '';
      });
    } else {
      setState(() {
        errorMessage = 'Failed to fetch employee data';
      });
    }
  }

  Future<void> fetchStatus() async {
    final statusResponse = await EmployeeStatusApiServices.fetchStatusRecords();

    if (statusResponse != null && statusResponse.Data != null) {
      setState(() {
        status = statusResponse.Data!.status;
        checkInTime = statusResponse.Data!.checkInTime;
        checkOutTime = statusResponse.Data!.checkOutTime;
        errorMessage = '';
      });
    } else {
      setState(() {
        errorMessage = 'Failed to fetch employee status';
      });
    }
  }

  //greeting
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} "
        "${_monthName(date.month)} "
        "${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  // Helper widget function for fallback image
  Widget _buildFallbackImage() {
    return Container(
      height: 100.h,
      width: 100.h,
      color: Colors.grey[300],
      child: const Icon(Icons.person, size: 60, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scaffoldKey: widget.scaffoldKey,
      onDrawerChanged: widget.onDrawerChanged,
      title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      centerTitle: true,
      drawer: const MenubarDrawer(),
      leadingWidget: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppPadding.basePagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  ClipOval(
                                    child:
                                        (imageUrl != null &&
                                                imageUrl!.isNotEmpty)
                                            ? Image.network(
                                              '${Config.baseUrl}${imageUrl!.startsWith('/') ? '' : '/'}$imageUrl',
                                              height: 67.h,
                                              width: 67.h,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                // Show fallback container with icon if image load fails
                                                return _buildFallbackImage();
                                              },
                                            )
                                            : _buildFallbackImage(),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    " ${formatDate(DateTime.now())}",
                                    style:
                                        context
                                            .textStyle(
                                              palette: ColorPalette.zinc,
                                            )
                                            .small,
                                  ),
                                ],
                              ),

                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getGreeting(),
                                      style:
                                          context
                                              .textStyle(
                                                palette:
                                                    ColorPalette.sherpa_blue,
                                              )
                                              .header5
                                              .bold,
                                    ),

                                    Text(
                                      fullName ?? '',
                                      style:
                                          context
                                              .textStyle(
                                                palette: ColorPalette.zinc,
                                              )
                                              .medium,
                                    ),
                                    Text(
                                      position ?? '',
                                      style:
                                          context
                                              .textStyle(
                                                palette: ColorPalette.zinc,
                                              )
                                              .small,
                                    ),
                                    Text(
                                      department ?? '',
                                      style:
                                          context
                                              .textStyle(
                                                palette: ColorPalette.zinc,
                                              )
                                              .medium,
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Text(
                      //   'Welcome back, ${fullName ?? 'User'}',
                      //   style:
                      //       context
                      //           .textStyle(palette: ColorPalette.sherpa_blue)
                      //           .header4
                      //           .bold,
                      // ),
                      SizedBox(height: 20.h),

                      /// Status Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: AppPadding.cardPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Today's Status",
                                    style:
                                        context
                                            .textStyle(
                                              palette: ColorPalette.sherpa_blue,
                                            )
                                            .header6
                                            .bold,
                                  ),
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Text("Status: ${status ?? '-'}"),
                              Text("Check In: ${formatFullTime(checkInTime)}"),
                              Text(
                                "Check Out: ${formatFullTime(checkOutTime)}",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Profile Information
                      Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: AppPadding.cardPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profile Information",
                                    style:
                                        context
                                            .textStyle(
                                              palette: ColorPalette.sherpa_blue,
                                            )
                                            .header6
                                            .bold,
                                  ),
                                  const Icon(Icons.person, color: Colors.green),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text("Department: ${department ?? '-'}"),
                              Text("Position: ${position ?? '-'}"),
                              Text(
                                "Employee ID: ${employeeId?.toString() ?? '-'}",
                              ),
                              Text("Email: ${email ?? '-'}"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Leave Request Table
                      const LeaveRequestTablePage(),
                    ],
                  ),
                ),
              ),
    );
  }
}
