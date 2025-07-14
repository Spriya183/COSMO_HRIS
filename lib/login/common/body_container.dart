import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InnerContainer extends StatelessWidget {
  final String title;
  final Color titlecolor;
  final Color borderColor;
  final Color backgroundColor;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color buttonTextColor;

  const InnerContainer({
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
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.r),
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
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: buttonTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
