import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendancePageContainer extends StatelessWidget {
  final String title;
  final Color titlecolor;
  final Color borderColor;
  final Color backgroundColor;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color buttonTextColor;

  const AttendancePageContainer({
    super.key,
    required this.title,
    required this.titlecolor,
    required this.borderColor,
    required this.backgroundColor,
    this.icon,
    required this.onPressed,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: AppPadding.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: titlecolor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: buttonTextColor),
                    SizedBox(width: 1.w),
                  ],
                  Text(
                    title,
                    style: TextStyle(fontSize: 16.sp, color: buttonTextColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
