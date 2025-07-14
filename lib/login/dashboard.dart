import 'package:attendance_system/api_services/employee_authentication_api_services.dart';
import 'package:attendance_system/api_services/employee_status_api_services.dart';
import 'package:attendance_system/common/base_page.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/login/common/menubar.dart';
import 'package:attendance_system/common/date_time_converter.dart';
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

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchEmployee();
    fetchStatus();
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
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Failed to fetch employee data';
        isLoading = false;
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
        isLoading = false;
      });
    } else {
      setState(() {
        fetchEmployee();
      });
    }
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
              : Padding(
                padding: EdgeInsets.all(25.r),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${fullName ?? 'User'}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      /// Status Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Today's Status",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.access_time, color: Colors.blue),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profile Information",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.person, color: Colors.green),
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

                      /// Leave Request Card (placeholder content)
                      // Card(
                      //   elevation: 2,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         const Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               "Recent Leave Requests",
                      //               style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             Icon(
                      //               Icons.calendar_today_outlined,
                      //               color: Colors.orange,
                      //             ),
                      //           ],
                      //         ),
                      //         const SizedBox(height: 20),
                      //         SingleChildScrollView(
                      //           scrollDirection: Axis.horizontal,
                      //           child: DataTable(
                      //             headingRowColor:
                      //                 const MaterialStatePropertyAll(
                      //                   Colors.grey,
                      //                 ),
                      //             columns: const [
                      //               DataColumn(label: Text('LEAVE TYPE')),
                      //               DataColumn(label: Text('START DATE')),
                      //               DataColumn(label: Text('END DATE')),
                      //               DataColumn(label: Text('STATUS')),
                      //               DataColumn(label: Text('REQUESTED ON')),
                      //             ],
                      //             rows: const [
                      //               DataRow(
                      //                 cells: [
                      //                   DataCell(Text('')),
                      //                   DataCell(Text('')),
                      //                   DataCell(Text('')),
                      //                   DataCell(Text('')),
                      //                   DataCell(Text('')),
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         const SizedBox(height: 10),
                      //         const Center(
                      //           child: Text("No leave requests found"),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
    );
  }
}
