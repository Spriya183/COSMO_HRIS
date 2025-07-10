import 'package:attendance_system/api_services/retrive_leave_request_data_api_services.dart';
import 'package:attendance_system/common/base_page.dart';
import 'package:attendance_system/common/date_time_converter.dart';
import 'package:attendance_system/login/common/add_new_leave_request.dart';
import 'package:attendance_system/model/attendance_model/retrive_leave_request_model.dart';
import 'package:flutter/material.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  List<retriveLeaveRequestData> requestList = [];

  Future<void> _handleFetchLeaveRequest() async {
    final Record =
        await RetriveLeaveRequestDataApiServices.fetchLeaveRequestRecords();

    if (Record['status']) {
      final response = Record['data'];
      setState(() {
        requestList = Record['data'];
      });
    } else {
      setState(() {
        requestList = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Record['message'] ?? 'Failed to load records')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _handleFetchLeaveRequest();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: const Text('Leave Request', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New Leave Request Button
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'View and manage your leave requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff004E64),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewLeaveRequestPage(),
                            ),
                          ).then((_) => _handleFetchLeaveRequest());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff004E64),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Request Leave',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),

              const Center(
                child: Text(
                  'Leave Requests',
                  style: TextStyle(
                    color: Color(0xff004E64),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Data Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Leave Type',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Start Date',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'End Date',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Reason',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Requested On',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                  rows:
                      requestList.map((entry) {
                        final dataMap = entry.toJson();
                        return DataRow(
                          cells: [
                            DataCell(Text(dataMap['leavePolicy'] ?? '-')),
                            DataCell(
                              Text(formatDateOnly(dataMap['startDate'])),
                            ),
                            DataCell(
                              Text(formatDateOnly(dataMap['endDate']) ?? '-'),
                            ),
                            DataCell(Text(dataMap['reason'] ?? '-')),
                            DataCell(Text(dataMap['status'] ?? '')),
                            DataCell(
                              Text(formatDateOnly(dataMap['createdAt']) ?? '-'),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
