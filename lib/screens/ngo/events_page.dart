import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ngo_home_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController registrationLinkController = TextEditingController();

  DateTime? selectedDateTime;
  bool _isSubmitting = false;

  final Color eventsBlue = const Color.fromARGB(255, 54, 116, 181);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getCurrentTimestamp() {
    DateTime now = DateTime.now().toUtc();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8E6E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8E6E1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: eventsBlue),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const NGODonationManagementHeader()),
              (route) => false,
            );
          },
        ),
        title: Text(
          'NGO Events Manager',
          style: GoogleFonts.poppins(
            color: eventsBlue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "🎯 NGO",
                style: GoogleFonts.poppins(
                  color: eventsBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Time Display
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[50]!, Colors.blue[100]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, color: eventsBlue, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "Current Time: ${_getCurrentTimestamp()} UTC",
                        style: GoogleFonts.poppins(
                          color: eventsBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Header text
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Create Events for Tejas2305 and Other Donors',
                    style: GoogleFonts.poppins(
                      color: eventsBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                _buildInputField(
                  controller: eventNameController,
                  hintText: 'Enter event name (e.g., Food Donation Drive)',
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: descriptionController,
                  hintText: 'Enter description (e.g., Join us to help the community)',
                  maxLines: 5,
                  height: 140,
                ),
                const SizedBox(height: 20),
                _buildDateTimeField(context),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: locationController,
                  hintText: 'Enter location (e.g., Community Center, City Hall)',
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: registrationLinkController,
                  hintText: 'Enter registration link (optional)',
                ),
                const SizedBox(height: 40),

                // Recent Events Section
                _buildRecentEventsSection(),

                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _addEventToFirebase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: eventsBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      child: _isSubmitting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Publishing...',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.publish, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Publish Event',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentEventsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: eventsBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Published Events',
                style: GoogleFonts.poppins(
                  color: eventsBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('events')
                .orderBy('createdAt', descending: true)
                .limit(3)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  'Error loading events',
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final events = snapshot.data?.docs ?? [];

              if (events.isEmpty) {
                return Text(
                  'No events published yet. Create your first event!',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                );
              }

              return Column(
                children: events.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.event, color: eventsBlue, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['eventName'] ?? 'Unknown Event',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: eventsBlue,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _formatEventDate(data['eventDateTime']),
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Live',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatEventDate(dynamic dateField) {
    try {
      DateTime date;
      
      if (dateField is Timestamp) {
        date = dateField.toDate();
      } else if (dateField is String) {
        date = DateTime.parse(dateField);
      } else {
        return 'Date not available';
      }

      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      String month = months[date.month - 1];
      
      return '${date.day} $month, ${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Future<void> _addEventToFirebase() async {
    // Validation
    if (eventNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter event name', Colors.red);
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showSnackBar('Please enter event description', Colors.red);
      return;
    }
    if (selectedDateTime == null) {
      _showSnackBar('Please select date and time', Colors.red);
      return;
    }
    if (locationController.text.trim().isEmpty) {
      _showSnackBar('Please enter event location', Colors.red);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      String currentTimestamp = _getCurrentTimestamp();
      
      // Create event data
      Map<String, dynamic> eventData = {
        'eventName': eventNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'eventDateTime': selectedDateTime!.toIso8601String(),
        'location': locationController.text.trim(),
        'registrationLink': registrationLinkController.text.trim(),
        'publishedBy': 'NGO System',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'publishedAt': DateTime.now().toUtc().toIso8601String(),
        'publishTimestamp': '$currentTimestamp UTC',
        'targetAudience': 'donors', // For Tejas2305 and other donors
      };

      // Add to Firestore
      DocumentReference docRef = await _firestore
          .collection('events')
          .add(eventData);

      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      _showSuccessDialog(docRef.id, currentTimestamp);

    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      _showSnackBar('Error publishing event: $e', Colors.red);
    }
  }

  void _showSuccessDialog(String eventId, String timestamp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 28),
              const SizedBox(width: 10),
              const Text("Event Published! 🎉"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your event is now live for all donors!",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: eventsBlue, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[50]!, Colors.green[100]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🆔 Event ID:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green[700])),
                      Text(eventId, style: GoogleFonts.poppins(fontSize: 10, color: Colors.green[600], fontWeight: FontWeight.w500, letterSpacing: 0.3)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow("🎯", "Event", eventNameController.text),
                _buildDetailRow("📅", "Date", "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}"),
                _buildDetailRow("🕐", "Time", "${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}"),
                _buildDetailRow("📍", "Location", locationController.text),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[50]!, Colors.blue[100]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Tejas2305 and other donors will see this event in their 'Upcoming Events' page!",
                          style: GoogleFonts.poppins(color: Colors.blue[700], fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text("⏰ Published: $timestamp UTC", 
                    style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600], letterSpacing: 0.5)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: Text("OK", style: GoogleFonts.poppins(color: eventsBlue, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$emoji ", style: const TextStyle(fontSize: 14)),
          SizedBox(
            width: 60,
            child: Text("$label:", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 13)),
          ),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13))),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      eventNameController.clear();
      descriptionController.clear();
      locationController.clear();
      registrationLinkController.clear();
      selectedDateTime = null;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    double? height,
  }) {
    return Container(
      width: double.infinity,
      height: height ?? 50,
      padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFD5D5D5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.poppins(
            color: const Color(0xFF666666),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF9C9C9C),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(BuildContext context) {
    String text = selectedDateTime == null
        ? 'Select Date & Time'
        : '${selectedDateTime!.day.toString().padLeft(2, '0')}/${selectedDateTime!.month.toString().padLeft(2, '0')}/${selectedDateTime!.year}   ${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: selectedDateTime ?? now,
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
        if (date != null) {
          TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: selectedDateTime != null
                ? TimeOfDay(hour: selectedDateTime!.hour, minute: selectedDateTime!.minute)
                : TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  textTheme: GoogleFonts.poppinsTextTheme(),
                ),
                child: child!,
              );
            },
          );
          if (time != null) {
            setState(() {
              selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
            });
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFD5D5D5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF9C9C9C)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: selectedDateTime == null ? const Color(0xFF9C9C9C) : const Color(0xFF666666),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    eventNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    registrationLinkController.dispose();
    super.dispose();
  }
}