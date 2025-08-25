import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_screen.dart';

class DonationReminderPage extends StatefulWidget {
  const DonationReminderPage({Key? key}) : super(key: key);

  @override
  State<DonationReminderPage> createState() => _DonationReminderPageState();
}

class _DonationReminderPageState extends State<DonationReminderPage> {
  final List<DonationDetailInput> _donationDetails = [DonationDetailInput()];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final Color mainBlue = const Color(0xFF4B81C1);

  void _addDonationDetail() {
    setState(() {
      _donationDetails.add(DonationDetailInput());
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submit() {
    bool allValid = true;
    for (var detail in _donationDetails) {
      if (detail.controller.text.trim().isEmpty) {
        allValid = false;
        break;
      }
    }
    if (!allValid || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all donation details and select date/time.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show dialog popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: mainBlue, size: 56),
              const SizedBox(height: 16),
              Text(
                "Donation Completed!",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: mainBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Thank you for setting a donation reminder.",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    // After 2.5 seconds, pop dialog and redirect to profile page
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context)
            ..pop() // close dialog
            ..pushReplacement(MaterialPageRoute(builder: (_) => const ProfileScreen()));
      }
    });
  }

  @override
  void dispose() {
    for (var detail in _donationDetails) {
      detail.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1F8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD1F8EF),
        elevation: 0,
        title: Text(
          "Donation Reminder",
          style: GoogleFonts.poppins(
            color: mainBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: mainBlue),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28.0),
              topRight: Radius.circular(28.0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Set up your donation reminder",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: mainBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _donationDetails.length,
                  itemBuilder: (context, idx) =>
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _donationDetails[idx].controller,
                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF3F9F7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: mainBlue),
                                ),
                                hintText: 'Donation detail ${idx + 1}',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF9C9C9C),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                              ),
                            ),
                          ),
                          if (_donationDetails.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _donationDetails.removeAt(idx);
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addDonationDetail,
                    icon: Icon(Icons.add, color: mainBlue),
                    label: Text(
                      "Add More",
                      style: GoogleFonts.poppins(color: mainBlue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5D5D5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFF9C9C9C), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                            style: GoogleFonts.poppins(
                              color: _selectedDate == null ? const Color(0xFF9C9C9C) : const Color(0xFF666666),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => _pickTime(context),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5D5D5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF9C9C9C), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedTime == null
                                ? 'Select Time'
                                : _selectedTime!.format(context),
                            style: GoogleFonts.poppins(
                              color: _selectedTime == null ? const Color(0xFF9C9C9C) : const Color(0xFF666666),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.5),
                        ),
                        elevation: 3,
                        textStyle: GoogleFonts.poppins(),
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DonationDetailInput {
  final TextEditingController controller = TextEditingController();
}