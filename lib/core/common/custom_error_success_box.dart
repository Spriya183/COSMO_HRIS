import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowDialog {
  final BuildContext context;

  ShowDialog({required this.context});

  void showSucessStateDialog({String? title, String? body, Function()? onTab}) {
    if (ModalRoute.of(context)?.isCurrent != true) {
      return;
    }

    // Show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Start auto-close timer AFTER the dialog is shown
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop(); // Auto close
            if (onTab != null) {
              onTab(); // Call callback after dialog closes, if provided
            }
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? "Success",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(thickness: 2),
              Text(
                body == null || body.isEmpty ? "Successful" : body,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  void showErrorStateDialog({String? title, String? body, Function()? onTab}) {
    if (ModalRoute.of(context)?.isCurrent != true) {
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? "Error",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Divider(thickness: 2),
                Text(
                  body == null || body.isEmpty ? "Something went wrong" : body,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
                const SizedBox(height: 15),
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 8,
                        left: 8,
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all(Size.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: onTab ?? () => Navigator.pop(context),
                  child: Text("Ok", style: TextStyle(color: Color(0xff323465))),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
