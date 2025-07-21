import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_date_time_converter.dart';
import 'package:attendance_system/feature/common/menubar_drawer.dart';
import 'package:attendance_system/feature/profile/imagePreview.dart';
import 'package:attendance_system/service/api_url.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/api_services/employee_authentication_api_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(bool) onDrawerChanged;

  const ProfilePage({
    super.key,
    required this.scaffoldKey,
    required this.onDrawerChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? fullName;
  String? position;
  String? email;
  String? phoneNumber;
  String? address;
  String? department;
  String? dob;
  String? dateOfJoining;
  String? gender;
  String? status;
  String? bloodGroup;
  String? imageUrl;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    employeeProfile();
  }

  Future<void> employeeProfile() async {
    final authResponse =
        await EmployeeAuthenticationApiServices.authenticateEmployee();

    if (authResponse != null && authResponse.data != null) {
      setState(() {
        fullName = authResponse.data!.fullName;
        position = authResponse.data!.position;
        email = authResponse.data!.email;
        phoneNumber = authResponse.data!.phoneNumber;
        address = authResponse.data!.address;
        department = authResponse.data!.department;
        dob = authResponse.data!.dob;
        dateOfJoining = authResponse.data!.dateOfJoining;
        gender = authResponse.data!.gender;
        status = authResponse.data!.status;
        bloodGroup = authResponse.data!.bloodGroup;
        imageUrl = authResponse.data!.imageUrl ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Failed to fetch employee data';
        isLoading = false;
      });
    }
  }

  Widget demoimage() {
    return Container(
      height: 120.h,
      width: 120.h,
      color: Colors.grey[300],
      child: const Icon(Icons.person, size: 60, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scaffoldKey: widget.scaffoldKey,
      onDrawerChanged: widget.onDrawerChanged,
      title: const Text(
        'Profile Information',
        style: TextStyle(color: Colors.white),
      ),
      drawer: const MenubarDrawer(),
      leadingWidget: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      showBackButton: false,
      centerTitle: true,
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: AppPadding.basePagePadding,
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    GestureDetector(
                      onTap: () {
                        if (imageUrl != null && imageUrl!.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ImagePreviewPage(
                                    imageUrl:
                                        '${Config.baseUrl}${imageUrl!.startsWith('/') ? '' : '/'}$imageUrl',
                                  ),
                            ),
                          );
                        }
                      },
                      child: ClipOval(
                        child:
                            (imageUrl != null && imageUrl!.isNotEmpty)
                                ? Image.network(
                                  '${Config.baseUrl}${imageUrl!.startsWith('/') ? '' : '/'}$imageUrl',
                                  height: 120.h,
                                  width: 120.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return demoimage();
                                  },
                                )
                                : demoimage(),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      fullName ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                      position ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      email ?? '',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),
                    Padding(
                      padding: AppPadding.cardPadding,
                      child: Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.r,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInfoRow(
                              Icons.phone,
                              "Phone Number",
                              phoneNumber,
                            ),
                            buildDivider(),
                            buildInfoRow(Icons.home, "Address", address),
                            buildDivider(),
                            buildInfoRow(
                              Icons.domain,
                              "Department",
                              department,
                            ),
                            buildDivider(),
                            buildInfoRow(
                              Icons.calendar_today,
                              "Date of Birth",
                              formatDateOnly(dob),
                            ),
                            buildDivider(),
                            buildInfoRow(
                              Icons.date_range,
                              "Date of Joining",
                              formatDateOnly(dateOfJoining),
                            ),
                            buildDivider(),
                            buildInfoRow(Icons.person, "Gender", gender),
                            buildDivider(),
                            buildInfoRow(Icons.verified_user, "Status", status),
                            buildDivider(),
                            buildInfoRow(
                              Icons.bloodtype,
                              "Blood Group",
                              bloodGroup,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black54),
        SizedBox(width: 16.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              Flexible(
                child: Text(
                  value ?? '-',
                  style: TextStyle(fontSize: 14.sp),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDivider() => SizedBox(height: 15.h, child: const Divider());
}
