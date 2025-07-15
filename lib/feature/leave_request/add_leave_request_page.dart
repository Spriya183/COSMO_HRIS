import 'package:attendance_system/api_services/add_leave_request_api_service.dart';
import 'package:attendance_system/api_services/fatch_leave_policy_api_services.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_dropdown.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/core/common/custom_form_field.dart';
import 'package:attendance_system/model/response_model/leave_type_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewLeaveRequestPage extends StatefulWidget {
  const NewLeaveRequestPage({super.key});

  @override
  State<NewLeaveRequestPage> createState() => _NewLeaveRequestPageState();
}

class _NewLeaveRequestPageState extends State<NewLeaveRequestPage> {
  DateTime? startDate;
  DateTime? endDate;

  final List<String> _leaveTypes = [];
  List<LeavePolicy> _leavePolicyObjects = [];

  @override
  void initState() {
    super.initState();
    _loadLeaveTypes();
  }

  Future<void> _loadLeaveTypes() async {
    final result = await FatchLeavePolicyApiServices.fetchLeavePolicy();

    if (result['status'] == true && result['data'] != null) {
      final List<LeavePolicy> leavePolicies = List<LeavePolicy>.from(
        result['data'],
      );

      setState(() {
        _leaveTypes.clear();
        _leavePolicyObjects = leavePolicies;
        _leaveTypes.addAll(leavePolicies.map((e) => e.leaveType));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to load leave types'),
        ),
      );
    }
  }

  final TextEditingController _reasonController = TextEditingController();

  String? _selectedLeaveType;

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('MM/dd/yyyy').format(date) : '';
  }

  Future<void> _handleLeaveRequest() async {
    if (startDate == null || endDate == null) {
      ShowDialog(
        context: context,
      ).showErrorStateDialog(body: 'Please Select both Start and End date');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Please select both Start and End dates."),
      //   ),
      // );
      return;
    }

    if (_selectedLeaveType == null || _selectedLeaveType!.isEmpty) {
      ShowDialog(
        context: context,
      ).showErrorStateDialog(body: "Please select a leave type.");

      return;
    }

    if (!_formKey.currentState!.validate()) {
      return; // Form validation failed
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await AddLeaveRequestApiService.addLeaveRequest(
        leaveType: _selectedLeaveType!,
        reason: _reasonController.text,
        startDate: startDate!,
        endDate: endDate!,
      );

      Navigator.pop(context); // dismiss loader

      ShowDialog(
        context: context,
      ).showErrorStateDialog(body: response['message']);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(response['message'] ?? 'summited successfully')),
      // );

      if (response['status'] == true) {
        _reasonController.clear();
        setState(() {
          _selectedLeaveType = null;
          startDate = null;
          endDate = null;
        });
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: const Text(
        'Add Leave Request',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Pickers
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: AbsorbPointer(
                        child: CustomTextfield(
                          label: "Start Date",
                          hint: "Select start date",
                          controller: TextEditingController(
                            text: _formatDate(startDate),
                          ),
                          validator: (value) {
                            if (startDate == null) return "Start date required";
                            return null;
                          },
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: AbsorbPointer(
                        child: CustomTextfield(
                          label: "End Date",
                          hint: "Select end date",
                          controller: TextEditingController(
                            text: _formatDate(endDate),
                          ),
                          validator: (value) {
                            if (endDate == null) return "End date required";
                            return null;
                          },
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Leave Type Dropdown
              CustomDropdown(
                label: "Leave Type",
                items: _leaveTypes,
                selectedValue: _selectedLeaveType,
                onChanged: (value) {
                  setState(() {
                    _selectedLeaveType = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Reason Field
              CustomTextfield(
                label: "Reason",
                hint: "Describe the reason for your leave",
                controller: _reasonController,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Reason is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff004E64),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleLeaveRequest,
                  child: const Text(
                    "Submit Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
