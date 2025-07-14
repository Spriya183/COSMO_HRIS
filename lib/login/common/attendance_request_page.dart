import 'package:attendance_system/api_services/attendance_request_api_servive.dart';
import 'package:attendance_system/common/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestAttendancePage extends StatefulWidget {
  const RequestAttendancePage({super.key});

  @override
  State<RequestAttendancePage> createState() => _RequestAttendancePageState();
}

class _RequestAttendancePageState extends State<RequestAttendancePage> {
  String _selectedType = 'Check In';
  TimeOfDay? _selectedTime;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _commentController = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleAttendanceRequest() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a time.")));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response =
          await AttendanceRequestApiService.attendanceRequestRecord(
            type: _selectedType,
            hour: _selectedTime!.hour,
            minute: _selectedTime!.minute,
            comment: _commentController.text,
            date: _selectedDate,
          );

      Navigator.pop(context);

      // Show a custom message based on the selected type
      String typeMessage =
          _selectedType == "Check In"
              ? "Checked submitted successfully."
              : "Checked submitted successfully.";

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(typeMessage)));
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: const Text(
        'Attendance Request',
        style: TextStyle(color: Colors.white),
      ),
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),

      centerTitle: true,
      colors: const Color(0xff004E64),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            const Text(
              "Request Type",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Radio<String>(
                  value: "CHECK-IN",
                  groupValue: _selectedType,
                  onChanged: (value) => setState(() => _selectedType = value!),
                ),
                const Text("Check In"),
                SizedBox(width: 20.w),
                Radio<String>(
                  value: "CHECK-OUT",
                  groupValue: _selectedType,
                  onChanged: (value) => setState(() => _selectedType = value!),
                ),
                const Text("Check Out"),
              ],
            ),
            SizedBox(height: 20.h),
            const Text("Time", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : "--:-- --",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            const Text(
              "Comment",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6.h),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Describe the cause",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            const Text("Date", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      "${_selectedDate.day.toString().padLeft(2, '0')}/"
                      "${_selectedDate.month.toString().padLeft(2, '0')}/"
                      "${_selectedDate.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleAttendanceRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff004E64),
                    ),
                    child: const Text(
                      "Submit Request",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
