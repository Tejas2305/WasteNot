import 'package:flutter/material.dart';

class SpecialDaysScreen extends StatelessWidget {
  const SpecialDaysScreen({Key? key}) : super(key: key);

  // Example JSON data for special days (this would ideally come from an API or local JSON file)
  final List<Map<String, dynamic>> specialDaysJson = const [
    {
      "title": "World Food Day",
      "iconPath": "assets/Images/earth1.png",
      "date": "16 October",
      "description":
          "Raise awareness about hunger and take action to ensure everyone has access to nutritious food."
    },
    {
      "title": "World Book Day",
      "iconPath": "assets/Images/book1.png",
      "date": "23 April",
      "description":
          "Celebrate reading, share books, and inspire a love for knowledge."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFDBF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFDBF6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Special Days',
          style: TextStyle(
            color: Color(0xFF5C2C9C),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF5C2C9C)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Main White Container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Celebrate Text with Custom Calendar Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/Images/calendar2.png",
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 10),
                        const Flexible(
                          child: Text(
                            "Celebrate and contribute on these\nmeaningful days!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF5C2C9C),
                              fontWeight: FontWeight.w600,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Dynamically render special day cards from JSON
                    ...specialDaysJson.map((day) => Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: _specialDayCard(
                            title: day['title'],
                            iconPath: day['iconPath'],
                            date: day['date'],
                            description: day['description'],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialDayCard({
    required String title,
    required String iconPath,
    required String date,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x5A5C2C9C), // 35% opacity of #5C2C9C
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Icon
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.2,
                        ),
                      ),
                    ),
                    Image.asset(
                      iconPath,
                      height: 33,
                      width: 33,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.black, // Changed to black
                    fontWeight: FontWeight.w400,
                    fontSize: 13.3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black, // Changed to black
                    fontSize: 12.4,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}