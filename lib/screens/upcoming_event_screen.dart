import 'package:flutter/material.dart';
import 'dart:math';

class UpcomingEventsScreen extends StatefulWidget {
  @override
  _UpcomingEventsScreenState createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> events = [
    {
      "title": "Food Donation Camp",
      "date": "June 12, 2025",
      "time": "10:00 AM - 4:00 PM",
      "location": "Community Center",
      "icon": Icons.volunteer_activism,
      "color": Color(0xFFB17CDF),
      "description": "Join us in making a difference by donating food to those in need."
    },
    {
      "title": "Waste Management Seminar",
      "date": "July 8, 2025",
      "time": "2:00 PM - 5:00 PM",
      "location": "City Hall Auditorium",
      "icon": Icons.recycling,
      "color": Color(0xFF772AB9),
      "description": "Learn about sustainable waste management practices for our community."
    },
    {
      "title": "Community Awareness Drive",
      "date": "August 18, 2025",
      "time": "9:00 AM - 6:00 PM",
      "location": "Central Square",
      "icon": Icons.campaign,
      "color": Color(0xFF9478B9),
      "description": "Spreading awareness about important social issues in our neighborhood."
    },
  ];

  late AnimationController _controller;
  late Animation<double> _waveAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _waveAnim = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedBackground(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveAnim,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEFDBF6), Color(0xFF9478B9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                painter: _WavyPainter(_waveAnim.value),
                child: Container(height: 120),
              ),
            ),
            Positioned(
              bottom: -30 + 10 * sin(_waveAnim.value),
              right: -60,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF772AB9).withOpacity(0.13),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFDBF6),
      appBar: AppBar(
        title: Text(
          "Upcoming Events",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF5C2C9C),
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Color(0xFF5C2C9C),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _animatedBackground(context),
          Padding(
            padding: EdgeInsets.only(top: 100.0, left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Don't miss out on these amazing events!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF9478B9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 700 + index * 200),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * 40),
                              child: child,
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shadowColor: event['color'].withOpacity(0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Selected: ${event['title']}"),
                                  backgroundColor: event['color'],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: event['color'].withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      event['icon'],
                                      color: event['color'],
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event['title'],
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF5C2C9C),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today, size: 15, color: Color(0xFF9478B9)),
                                            SizedBox(width: 4),
                                            Text(
                                              event['date'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF9478B9),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 15, color: Color(0xFF9478B9)),
                                            SizedBox(width: 4),
                                            Text(
                                              event['time'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFB17CDF),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 15, color: Color(0xFF9478B9)),
                                            SizedBox(width: 4),
                                            Text(
                                              event['location'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF9478B9),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          event['description'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF5C2C9C),
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, color: Color(0xFFB17CDF), size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _waveAnim,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + 0.03 * sin(_waveAnim.value),
            child: FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Add new event feature coming soon!"),
                    backgroundColor: Color(0xFF5C2C9C),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text("Add Event", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              backgroundColor: Color(0xFFB17CDF),
            ),
          );
        },
      ),
    );
  }
}

class _WavyPainter extends CustomPainter {
  final double waveValue;
  _WavyPainter(this.waveValue);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFFB17CDF), Color(0xFFEFDBF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    path.moveTo(0, size.height * 0.6);
    for (double x = 0; x <= size.width; x += 1) {
      path.lineTo(
        x,
        size.height * 0.6 +
            18 * sin((x / size.width * 2 * pi) + waveValue),
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavyPainter oldDelegate) {
    return oldDelegate.waveValue != waveValue;
  }
}