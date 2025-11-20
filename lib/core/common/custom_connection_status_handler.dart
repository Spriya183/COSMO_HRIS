import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectionStatusHandler extends StatefulWidget {
  final Widget child;

  const ConnectionStatusHandler({Key? key, required this.child})
    : super(key: key);

  @override
  State<ConnectionStatusHandler> createState() =>
      _ConnectionStatusHandlerState();
}

class _ConnectionStatusHandlerState extends State<ConnectionStatusHandler> {
  bool _dialogShown = false;
  late final StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      final isOffline = result == ConnectivityResult.none;

      if (isOffline && !_dialogShown) {
        _dialogShown = true;
        _showNoConnectionDialog();
      } else if (!isOffline && _dialogShown) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(); // Dismiss dialog
        }
        _dialogShown = false;
      }
    });
  }

  void _showNoConnectionDialog() {
    Future.microtask(() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              icon: Icon(Icons.wifi_off, color: Colors.red, size: 50.w),
              title: Text(
                "Connection Error",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
              ),
              content: Text(
                "Could not connect to the server at this moment. Please check your network and try again.",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _dialogShown = false;
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
