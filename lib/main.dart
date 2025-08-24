// import 'package:flutter/material.dart';
// import 'screens/home_page.dart';
// import 'screens/donate_food_screen.dart';
// import 'screens/donate_clothes_screen.dart';
// import 'screens/donate_books_screen.dart';

// void main() {
//   runApp(const WasteNotApp());
// }

// class WasteNotApp extends StatelessWidget {
//   const WasteNotApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "WasteNot",
//       home: const MainScaffold(),
//     );
//   }
// }

// class MainScaffold extends StatefulWidget {
//   const MainScaffold({super.key});
//   @override
//   State<MainScaffold> createState() => _MainScaffoldState();
// }

// class _MainScaffoldState extends State<MainScaffold> {
//   // Which main tab? 0 = home, 1 = donations history, 2 = notifications, 3 = profile
//   int _selectedIndex = 0;
//   // For donation screens from home page donation options (-1 means none, 0=food, 1=clothes, 2=books)
//   int _donationPage = -1;

//   void _onNavTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//       _donationPage = -1;
//     });
//   }

//   void _openDonationScreen(int screenIndex) {
//     setState(() {
//       _selectedIndex = 0; // always home tab for donation forms
//       _donationPage = screenIndex;
//     });
//   }

//   void _backToHomeFromDonation() {
//     setState(() {
//       _donationPage = -1;
//     });
//   }

//   Widget get _body {
//     if (_selectedIndex == 0 && _donationPage == 0) {
//       return DonateFoodScreen(
//         selectedIndex: 0,
//         onNavTap: (_) => _backToHomeFromDonation(),
//       );
//     }
//     if (_selectedIndex == 0 && _donationPage == 1) {
//       return DonateClothesScreen(
//         selectedIndex: 0,
//         onNavTap: (_) => _backToHomeFromDonation(),
//       );
//     }
//     if (_selectedIndex == 0 && _donationPage == 2) {
//       return DonateBooksScreen(
//         selectedIndex: 0,
//         onNavTap: (_) => _backToHomeFromDonation(),
//       );
//     }
//     // Show home page, pass logic for donation options
//     if (_selectedIndex == 0) {
//       return HomePage(onDonationOptionTap: _openDonationScreen);
//     }
//     // Other tabs can go here (donation history, notifications, profile)
//     return Center(child: Text("Tab $_selectedIndex")); // replace with your actual widgets
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _body,
//       bottomNavigationBar: WasteNotNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onNavTap,
//       ),
//     );
//   }
// }

// /// --- Shared Bottom Navigation Bar ---
// class WasteNotNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onItemTapped;
//   const WasteNotNavBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: const BoxDecoration(
//         color: Color(0xFFF2E1FA),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.home_outlined, "Home", 0),
//           _buildNavItem(Icons.volunteer_activism, "Donations", 1),
//           _buildNavItem(Icons.notifications_none, "Notification", 2),
//           _buildNavItem(Icons.person_outline, "Profile", 3),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     final isSelected = selectedIndex == index;
//     return GestureDetector(
//       onTap: () => onItemTapped(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: Color(0xFF5C2C9C),
//               size: 28,
//             ),
//             if (isSelected) ...[
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Color(0xFF5C2C9C),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'screens/home_page.dart';
// import 'screens/donate_food_screen.dart';
// import 'screens/donate_clothes_screen.dart';
// import 'screens/donate_books_screen.dart';
// import 'screens/profile_screen.dart';
// import 'screens/notification_screen.dart';

// void main() {
//   runApp(const WasteNotApp());
// }

// class WasteNotApp extends StatelessWidget {
//   const WasteNotApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "WasteNot",
//       home: const MainScaffold(),
//     );
//   }
// }

// class MainScaffold extends StatefulWidget {
//   const MainScaffold({super.key});
//   @override
//   State<MainScaffold> createState() => _MainScaffoldState();
// }

// class _MainScaffoldState extends State<MainScaffold> {
//   // 0 = home, 1 = donations history, 2 = notifications, 3 = profile
//   int _selectedIndex = 0;
//   // For donation screens from home page donation options (-1 means none, 0=food, 1=clothes, 2=books)
//   int _donationPage = -1;

//   void _onNavTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//       _donationPage = -1;
//     });
//   }

//   void _openDonationScreen(int screenIndex) {
//     setState(() {
//       _selectedIndex = 0; // always home tab for donation forms
//       _donationPage = screenIndex;
//     });
//   }

//   void _backToHomeFromDonation() {
//     setState(() {
//       _donationPage = -1;
//     });
//   }

//   Widget get _body {
//     // Donation screens from home page
//     if (_selectedIndex == 0 && _donationPage == 0) {
//       return DonateFoodScreen(
//         selectedIndex: 0,
//         onNavTap: (_) => _backToHomeFromDonation(),
//       );
//     }
//     if (_selectedIndex == 0 && _donationPage == 1) {
//       return DonateClothesScreen(
//         selectedIndex: 0,
//         onNavTap: (_) => _backToHomeFromDonation(),
//       );
//     }
//     if (_selectedIndex == 0 && _donationPage == 2) {
//       return DonateBooksScreen(
//         selectedIndex: 0,
//         onNavTap: (_) => _backToHomeFromDonation(),
//       );
//     }
//     // Home tab
//     if (_selectedIndex == 0) {
//       return HomePage(onDonationOptionTap: _openDonationScreen);
//     }
//     // Donations history tab (replace with your history screen if needed)
//     if (_selectedIndex == 1) {
//       return Center(child: Text("Donations History Page"));
//     }
//     // Notification tab
//     if (_selectedIndex == 2) {
//       return NotificationScreen();
//     }
//     // Profile tab
//     if (_selectedIndex == 3) {
//       return ProfileScreen();
//     }
//     // Fallback
//     return Center(child: Text("Tab $_selectedIndex"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _body,
//       bottomNavigationBar: WasteNotNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onNavTap,
//       ),
//     );
//   }
// }

// /// --- Shared Bottom Navigation Bar ---
// class WasteNotNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onItemTapped;
//   const WasteNotNavBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: const BoxDecoration(
//         color: Color(0xFFF2E1FA),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.home_outlined, "Home", 0),
//           _buildNavItem(Icons.volunteer_activism, "Donations", 1),
//           _buildNavItem(Icons.notifications_none, "Notification", 2),
//           _buildNavItem(Icons.person_outline, "Profile", 3),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     final isSelected = selectedIndex == index;
//     return GestureDetector(
//       onTap: () => onItemTapped(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: Color(0xFF5C2C9C),
//               size: 28,
//             ),
//             if (isSelected) ...[
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Color(0xFF5C2C9C),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
 



import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Make sure this is the correct path

void main() {
  runApp(const WasteNotApp());
}

class WasteNotApp extends StatelessWidget {
  const WasteNotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WasteNot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Optional: Set your preferred font
      ),
      home: const WelcomeScreen(),
    );
  }
}
