import 'package:flutter/material.dart';
import 'dart:convert';

// Mock data to simulate JSON loading.
const String mockJson = '''
[
  {
    "icon": "check_circle",
    "iconColor": "#29C96C",
    "status": "Completed",
    "statusBg": "#29C96C",
    "statusText": "#FFFFFF",
    "borderColor": "#29C96C",
    "title": "Rice",
    "infoBorderColor": "#3DA9F5",
    "infoBg": "#143DA9F5",
    "donorBorderColor": "#42EAC3",
    "donorBg": "#F2FFFB",
    "type": "Cooked food",
    "quantity": "50 kg",
    "location": "Flat No. 12, Sai Residency, Baner Road, Baner, Pune – 411045",
    "timeLeft": "12 March 2023 – 03:45 PM",
    "email": "sharvari.kulkarni23@gmail.com",
    "phone": "+91 98234 56789"
  },
  {
    "icon": "watch_later",
    "iconColor": "#FFBA27",
    "status": "Pending",
    "statusBg": "#FFBA27",
    "statusText": "#FFFFFF",
    "borderColor": "#FFBA27",
    "title": "Book",
    "infoBorderColor": "#FFBA27",
    "infoBg": "#16FFBA27",
    "donorBorderColor": "#FFBA27",
    "donorBg": "#16FFBA27",
    "type": "Cooked food",
    "quantity": "50 kg",
    "location": "Flat No. 12, Sai Residency, Baner Road, Baner, Pune – 411045",
    "timeLeft": "12 March 2023 – 03:45 PM",
    "email": "sharvari.kulkarni23@gmail.com",
    "phone": "+91 98234 56789"
  }
]
''';

class NGODonationManagementHeader extends StatelessWidget {
  const NGODonationManagementHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1F8EF),
      body: Stack(
        children: [
          // White background with curved top
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 90),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
              ),
            ),
          ),
          const _NGODonationPageBody(),
        ],
      ),
    );
  }
}

class _NGODonationPageBody extends StatefulWidget {
  const _NGODonationPageBody();

  @override
  State<_NGODonationPageBody> createState() => _NGODonationPageBodyState();
}

class _NGODonationPageBodyState extends State<_NGODonationPageBody> {
  final List<String> statuses = ["Sort by", "Completed", "Pending", "Accepted", "Denied"];
  String selectedStatus = "Sort by";

  late List<DonationModel> donations;

  @override
  void initState() {
    super.initState();
    donations = (json.decode(mockJson) as List)
        .map((item) => DonationModel.fromJson(item))
        .toList();
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/Images/profile.png"),
            ),
            const SizedBox(height: 14),
            const Text(
              "NGO Admin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Color(0xFF3674B5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "admin@email.com",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3674B5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Add logout or profile logic here
              },
              child: const Text("Close"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DonationModel> filteredDonations = selectedStatus == "Sort by"
        ? donations
        : donations.where((d) => d.status == selectedStatus).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4B81C1)),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "NGO Donation",
                        style: TextStyle(
                          color: Color(0xFF4B81C1),
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Management",
                        style: TextStyle(
                          color: Color(0xFF4B81C1),
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showProfileSheet(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFA5DBF6), Color(0xFF5CA9DD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2.5),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("assets/Images/profile.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Dropdown
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 18, bottom: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F9F7),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    isExpanded: false,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 25),
                    borderRadius: BorderRadius.circular(12),
                    style: const TextStyle(
                      color: Color(0xFF3A3A3A),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    items: statuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status,
                          style: TextStyle(
                            color: status == "Sort by" ? const Color(0xFF3A3A3A) : Colors.black,
                            fontWeight: status == "Sort by" ? FontWeight.w600 : FontWeight.w500,
                            fontSize: status == "Sort by" ? 15 : 13,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue ?? "Sort by";
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          // Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: filteredDonations.map((donation) => DonationCard.fromModel(donation)).toList(),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

// Donation Model and helpers
class DonationModel {
  final String icon;
  final Color iconColor;
  final String status;
  final Color statusBg;
  final Color statusText;
  final Color borderColor;
  final String title;
  final Color infoBorderColor;
  final Color infoBg;
  final Color donorBorderColor;
  final Color donorBg;
  final String type;
  final String quantity;
  final String location;
  final String timeLeft;
  final String email;
  final String phone;

  DonationModel({
    required this.icon,
    required this.iconColor,
    required this.status,
    required this.statusBg,
    required this.statusText,
    required this.borderColor,
    required this.title,
    required this.infoBorderColor,
    required this.infoBg,
    required this.donorBorderColor,
    required this.donorBg,
    required this.type,
    required this.quantity,
    required this.location,
    required this.timeLeft,
    required this.email,
    required this.phone,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      icon: json['icon'],
      iconColor: _hexToColor(json['iconColor']),
      status: json['status'],
      statusBg: _hexToColor(json['statusBg']),
      statusText: _hexToColor(json['statusText']),
      borderColor: _hexToColor(json['borderColor']),
      title: json['title'],
      infoBorderColor: _hexToColor(json['infoBorderColor']),
      infoBg: _hexToColor(json['infoBg']),
      donorBorderColor: _hexToColor(json['donorBorderColor']),
      donorBg: _hexToColor(json['donorBg']),
      type: json['type'],
      quantity: json['quantity'],
      location: json['location'],
      timeLeft: json['timeLeft'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

Color _hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  if (hex.length == 8) {
    return Color(int.parse(hex, radix: 16));
  }
  return Colors.grey;
}

IconData _iconFromString(String iconName) {
  switch (iconName) {
    case 'check_circle':
      return Icons.check_circle;
    case 'watch_later':
      return Icons.watch_later;
    case 'pending':
      return Icons.watch_later_outlined;
    case 'accepted':
      return Icons.check_circle_outline;
    case 'denied':
      return Icons.cancel;
    default:
      return Icons.help_outline;
  }
}

// Donation Card Widget
class DonationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String status;
  final Color statusBg;
  final Color statusText;
  final Color borderColor;
  final String title;
  final Color infoBorderColor;
  final Color infoBg;
  final Color donorBorderColor;
  final Color donorBg;
  final String type;
  final String quantity;
  final String location;
  final String timeLeft;
  final String email;
  final String phone;

  const DonationCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.status,
    required this.statusBg,
    required this.statusText,
    required this.borderColor,
    required this.title,
    required this.infoBorderColor,
    required this.infoBg,
    required this.donorBorderColor,
    required this.donorBg,
    required this.type,
    required this.quantity,
    required this.location,
    required this.timeLeft,
    required this.email,
    required this.phone,
  }) : super(key: key);

  factory DonationCard.fromModel(DonationModel model) {
    return DonationCard(
      icon: _iconFromString(model.icon),
      iconColor: model.iconColor,
      status: model.status,
      statusBg: model.statusBg,
      statusText: model.statusText,
      borderColor: model.borderColor,
      title: model.title,
      infoBorderColor: model.infoBorderColor,
      infoBg: model.infoBg,
      donorBorderColor: model.donorBorderColor,
      donorBg: model.donorBg,
      type: model.type,
      quantity: model.quantity,
      location: model.location,
      timeLeft: model.timeLeft,
      email: model.email,
      phone: model.phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 11,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icon + title + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.11),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 27),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF222B45),
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusText,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 11),
          // Info Box (blue)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: infoBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: infoBorderColor,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _iconTextRow(Icons.fastfood_outlined, "Type : $type"),
                const SizedBox(height: 4),
                _iconTextRow(Icons.scale, "Quantity : $quantity"),
                const SizedBox(height: 4),
                _iconTextRow(Icons.location_on_outlined, "Location : $location"),
                const SizedBox(height: 4),
                _iconTextRow(Icons.schedule, "Time left : $timeLeft"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Donor Info Box
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: donorBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: donorBorderColor,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Donor Information",
                  style: TextStyle(
                    color: Color(0xFF3AAFA6),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                _iconTextRow(Icons.email_outlined, "Email : $email"),
                const SizedBox(height: 3),
                _iconTextRow(Icons.phone_outlined, "Phone No. : $phone"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconTextRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF3DA9F5), size: 13),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF2A3B4D),
              fontSize: 11.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}