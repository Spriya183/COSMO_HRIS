import 'package:attendance_system/api_services/logout_api_service.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/feature/login/login_page.dart';
import 'package:attendance_system/feature/logout/custom_logout_dialogue_box.dart';
import 'package:attendance_system/feature/profile/profile.dart';
import 'package:attendance_system/feature/setting/card.dart';
import 'package:attendance_system/feature/setting/change_password.dart';
import 'package:attendance_system/service/api_url.dart';
import 'package:attendance_system/api_services/employee_authentication_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? imageUrl;
  String? fullName;
  String? position;
  bool isLoading = true;
  String errorMessage = '';

  final GlobalKey<ScaffoldState> tempKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchEmployeeProfile();
  }

  Future<void> fetchEmployeeProfile() async {
    final authResponse =
        await EmployeeAuthenticationApiServices.authenticateEmployee();

    if (authResponse != null && authResponse.data != null) {
      setState(() {
        imageUrl = authResponse.data!.imageUrl ?? '';
        fullName = authResponse.data!.fullName ?? '';
        position = authResponse.data!.position ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Failed to fetch employee data';
        isLoading = false;
      });
    }
  }

  Widget demoImage() {
    return CircleAvatar(
      radius: 25.r,
      backgroundColor: Colors.grey[300],
      child: const Icon(Icons.person, size: 30, color: Colors.grey),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await LogoutApiService.employeeLogout();
      Navigator.pop(context); // Dismiss loading dialog

      if (result['code'] == 200) {
        // Show success message
        Future.delayed(Duration(microseconds: 100), () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Loginpage()),
            (route) => false,
          );
        });

        // ShowDialog(
        //   context: context,
        // ).showSucessStateDialog(body: result['message']);

        // // Navigate to login page and clear previous routes
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Loginpage()),
        //   (route) => false,
        // );
      } else {
        // Show failure message
        ShowDialog(
          context: context,
        ).showErrorStateDialog(body: result['message']);
      }
    } catch (e) {
      Navigator.pop(context); // Ensure dialog is dismissed on error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: const Text('Setting', style: TextStyle(color: Colors.white)),
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12.r),
                        leading:
                            (imageUrl != null && imageUrl!.isNotEmpty)
                                ? CircleAvatar(
                                  radius: 25.r,
                                  backgroundImage: NetworkImage(
                                    '${Config.baseUrl}${imageUrl!.startsWith('/') ? '' : '/'}$imageUrl',
                                  ),
                                  onBackgroundImageError: (_, __) {},
                                )
                                : demoImage(),
                        title: Text(
                          fullName ?? '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          position ?? '',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProfilePage(
                                    scaffoldKey: tempKey,
                                    onDrawerChanged: (isOpen) {},
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomCard(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.lock_outline),
                            title: const Text('Change Password'),
                            subtitle: const Text('Update your password'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ChangePasswordPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(),

                          ListTile(
                            leading: const Icon(Icons.notifications_none),
                            title: const Text('Notifications'),
                            subtitle: const Text(
                              'Manage notification preferences',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              // Implement navigation
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomCard(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.brightness_2_outlined),
                            title: const Text('Theme'),
                            subtitle: const Text('Light'),
                            trailing: const Icon(Icons.expand_more),
                            onTap: () {
                              // Implement theme options
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.language),
                            title: const Text('Language'),
                            subtitle: const Text('English'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              // Implement language settings
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomCard(
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        subtitle: const Text('sign out your account'),

                        onTap: () async {
                          final shouldLogout = await showLogoutDialog(context);

                          if (shouldLogout == true) {
                            await _handleLogout(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
