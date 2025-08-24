import 'package:flutter/material.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Dummy donation data (replace image paths with your asset paths or network images)
  final List<Map<String, dynamic>> allDonations = [
    {
      "ngo": "Smile Foundation",
      "title": "Books & Stationery for Underprivileged Students",
      "progress": "Progress Bar",
      "date": "21 Aug 2025, 5:45 PM",
      "image": "assets/images/img1.jpg",
    },
    {
      "ngo": "Akshay Patra Foundation",
      "title": "Food Drive for Children",
      "progress": "Progress Bar",
      "date": "12 Sep 2025, 2:30 PM",
      "image": "assets/images/img2.jpg",
    },
    {
      "ngo": "Smile Foundation",
      "title": "Sponsor Mid-Day Meals for School Children",
      "progress": "Progress Bar",
      "date": "30 Jul 2025, 9:45 AM",
      "image": "assets/images/img3.jpg",
    },
    {
      "ngo": "Organizer",
      "title": "Library Books for Underprivileged Schools",
      "progress": "Progress Bar",
      "date": "03 Apr 2025, 10:55 AM",
      "image": "assets/images/img4.jpg",
    }
  ];

  List<Map<String, dynamic>> get filteredDonations {
    if (_searchQuery.isEmpty) return allDonations;
    return allDonations
        .where((donation) =>
            donation['ngo'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            donation['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1E5FC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Donations',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main White Container
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Search Donation",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                          hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontWeight: FontWeight.w500),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Donation Cards Grid
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: filteredDonations.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 18,
                        childAspectRatio: 0.73,
                      ),
                      itemBuilder: (context, idx) {
                        final donation = filteredDonations[idx];
                        return _buildDonationCard(donation);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationCard(Map<String, dynamic> donation) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.11),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: Image.asset(
              donation['image'],
              fit: BoxFit.cover,
              height: 90,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NGO Name
                Text(
                  donation['ngo'],
                  style: const TextStyle(
                    color: Color(0xFF6667AB),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.8,
                  ),
                ),
                const SizedBox(height: 3),
                // Title
                Text(
                  donation['title'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.7,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Progress Bar Text
                Text(
                  donation['progress'],
                  style: const TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontWeight: FontWeight.w500,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 3),
                // Date
                Text(
                  "Donated on: ${donation['date']}",
                  style: const TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontWeight: FontWeight.w500,
                    fontSize: 11.5,
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