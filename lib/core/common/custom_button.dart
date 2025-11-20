import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final Widget? prefixIcon;
  final Color? iconColor;

  const CustomButton({
    super.key,
    required this.text,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    required this.onPressed,
    this.prefixIcon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xff004E64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          side: BorderSide(
            color: borderColor ?? backgroundColor ?? const Color(0xff004E64),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              IconTheme(
                data: IconThemeData(color: iconColor ?? Colors.white),
                child: prefixIcon!,
              ),

              SizedBox(width: 8.w),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
