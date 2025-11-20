import 'dart:ui';
import 'package:attendance_system/api_services/employee_authentication_api_services.dart';
import 'package:attendance_system/api_services/employee_status_api_services.dart';
import 'package:attendance_system/constant/app_color.dart';
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
        // employeeId = authResponse.data!.id;
        // email = authResponse.data!.email;
        imageUrl = authResponse.data!.imageUrl ?? '';
        errorMessage = '';
      });
    } else {
      setState(() => errorMessage = 'Failed to fetch employee data');
    }
  }

  Future<void> fetchStatus() async {
    final statusResponse = await EmployeeStatusApiServices.fetchStatusRecords();
    if (statusResponse != null && statusResponse.Data != null) {
      setState(() {
        status = statusResponse.Data!.status;
        checkInTime = statusResponse.Data!.checkInTime;
        checkOutTime = statusResponse.Data!.checkOutTime;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon';
    } else if (hour >= 18 && hour < 22) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}";
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

  Widget _buildFallbackImage() {
    return Container(
      height: 100.h,
      width: 100.h,
      color: Colors.grey[300],
      child: const Icon(Icons.person, size: 60, color: Colors.grey),
    );
  }

  Widget _buildCheckStatusCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    Color baseColor;
    switch (status) {
      case "Present":
        baseColor = Colors.green;
        break;
      case "Leave":
        baseColor = Colors.orange;
        break;
      case "Absent":
        baseColor = Colors.red;
        break;
      default:
        baseColor = const Color(0xff004E64);
    }

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: baseColor.withOpacity(0.1),
          border: Border.all(color: baseColor, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: baseColor, size: 26),
            SizedBox(height: 6.h),
            Text(
              label,
              style: context
                  .textStyle(palette: ColorPalette.zinc)
                  .medium
                  .copyWith(color: baseColor, fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: context
                  .textStyle(palette: ColorPalette.zinc)
                  .medium
                  .copyWith(color: baseColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
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
              ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator()),
              )
              : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppPadding.basePagePadding,
                  child:
                      errorMessage.isNotEmpty
                          ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Center(child: Text(errorMessage)),
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// User Card
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
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              _buildFallbackImage(),
                                                    )
                                                    : _buildFallbackImage(),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            formatDate(DateTime.now()),
                                            style:
                                                context
                                                    .textStyle(
                                                      palette:
                                                          ColorPalette.zinc,
                                                    )
                                                    .small,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getGreeting(),
                                                style:
                                                    context
                                                        .textStyle(
                                                          palette:
                                                              ColorPalette
                                                                  .sherpa_blue,
                                                        )
                                                        .header5
                                                        .bold,
                                              ),
                                              const SizedBox(width: 50),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Text(
                                          //   getGreeting(),
                                          //   style:
                                          //       context
                                          //           .textStyle(
                                          //             palette:
                                          //                 ColorPalette
                                          //                     .sherpa_blue,
                                          //           )
                                          //           .header5
                                          //           .bold,
                                          // ),
                                          if (getGreeting() == 'Good Morning')
                                            Text(
                                              "Wishing you a bright and productive start to your day.",
                                              style:
                                                  context
                                                      .textStyle(
                                                        palette:
                                                            ColorPalette.zinc,
                                                      )
                                                      .xsmall,
                                            )
                                          else if (getGreeting() ==
                                              'Good Afternoon')
                                            Text(
                                              "Hope your afternoon is going well!",
                                              style:
                                                  context
                                                      .textStyle(
                                                        palette:
                                                            ColorPalette.zinc,
                                                      )
                                                      .xsmall,
                                            )
                                          else if (getGreeting().startsWith(
                                            'Good Evening',
                                          ))
                                            Text(
                                              "Relax and recharge for tomorrow.",
                                              style:
                                                  context
                                                      .textStyle(
                                                        palette:
                                                            ColorPalette.zinc,
                                                      )
                                                      .xsmall,
                                            )
                                          else
                                            Text(
                                              "Tomorrow is another chance to shine.",
                                              style:
                                                  context
                                                      .textStyle(
                                                        palette:
                                                            ColorPalette.zinc,
                                                      )
                                                      .xsmall,
                                            ),

                                          Text(
                                            fullName ?? '',
                                            style:
                                                context
                                                    .textStyle(
                                                      palette:
                                                          ColorPalette.zinc,
                                                    )
                                                    .medium,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                position ?? '',
                                                style:
                                                    context
                                                        .textStyle(
                                                          palette:
                                                              ColorPalette.zinc,
                                                        )
                                                        .small,
                                              ),
                                              Text(', '),
                                              Text(
                                                department ?? '',
                                                style:
                                                    context
                                                        .textStyle(
                                                          palette:
                                                              ColorPalette.zinc,
                                                        )
                                                        .small,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 20.h),

                              /// Status Card
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(20.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Today's Status",
                                        style:
                                            context
                                                .textStyle(
                                                  palette:
                                                      ColorPalette.sherpa_blue,
                                                )
                                                .header6
                                                .bold,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "Your attendance for today",
                                        style:
                                            context
                                                .textStyle(
                                                  palette: ColorPalette.zinc,
                                                )
                                                .medium,
                                      ),
                                      SizedBox(height: 12.h),
                                      Row(
                                        children: [
                                          Text(
                                            "Status: ",
                                            style:
                                                context
                                                    .textStyle(
                                                      palette:
                                                          ColorPalette.zinc,
                                                    )
                                                    .header6,
                                          ),
                                          Text(
                                            status ?? '-',
                                            style: context
                                                .textStyle(
                                                  palette: ColorPalette.zinc,
                                                )
                                                .header6
                                                .copyWith(
                                                  color:
                                                      status == "Leave"
                                                          ? Colors.orange
                                                          : status == "Absent"
                                                          ? Colors.red
                                                          : status == "Present"
                                                          ? Colors.green
                                                          : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildCheckStatusCard(
                                            icon: Icons.login,
                                            label: "Check In",
                                            value:
                                                checkInTime != null
                                                    ? formatFullTime(
                                                      checkInTime!,
                                                    )
                                                    : "Not checked in",
                                          ),
                                          _buildCheckStatusCard(
                                            icon: Icons.logout,
                                            label: "Check Out",
                                            value:
                                                checkOutTime != null
                                                    ? formatFullTime(
                                                      checkOutTime!,
                                                    )
                                                    : "Not checked out",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// Leave Table
                              const LeaveRequestTablePage(),
                            ],
                          ),
                ),
              ),
    );
  }
}
