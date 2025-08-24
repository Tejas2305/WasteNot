import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF3EBFD);
    const Color headingColor = Color(0xFF6F3FAF);
    const double headerHeight = 106; // Increased for more gap

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with more vertical space
            Container(
              height: headerHeight,
              color: backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 18, bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: headingColor, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Notification',
                      style: TextStyle(
                        color: headingColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        letterSpacing: 0.2,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            // White card area for notifications
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  itemCount: 2, // Example: two notifications
                  separatorBuilder: (_, __) => Divider(
                    color: Colors.grey.shade200,
                    thickness: 1,
                    height: 1,
                  ),
                  itemBuilder: (context, index) => const NotificationCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Color(0xFF7E55D8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification bell icon
          Padding(
            padding: const EdgeInsets.only(top: 5), // Aligns with text block
            child: Icon(Icons.notifications_none, color: iconColor, size: 28),
          ),
          const SizedBox(width: 12), // Tighter gap to text
          // Text block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Donation Sent',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  'Lorem ipsum dolor sit amet consectetur.\nNunc imperdiet ornare aliquet enim.',
                  style: TextStyle(
                    fontSize: 16.2,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 5),
                // Date
                Text(
                  'Date',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13.3,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}