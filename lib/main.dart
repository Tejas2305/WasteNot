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
 


// import 'package:flutter/material.dart';
// import 'screens/welcome_screen.dart'; // Make sure this is the correct path

// void main() async {
//   // This line is required for location services and Google Maps
//   WidgetsFlutterBinding.ensureInitialized();
  
//   runApp(const WasteNotApp());
// }

// class WasteNotApp extends StatelessWidget {
//   const WasteNotApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'WasteNot',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: Colors.white,
//         fontFamily: 'Roboto', // Optional: Set your preferred font
//       ),
//       home: const WelcomeScreen(),
//     );
//   }
// }











// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';
// import 'screens/welcome_screen.dart';

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
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//         fontFamily: 'Roboto',
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> 
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late AnimationController _rotateController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotateAnimation;

//   @override
//   void initState() {
//     super.initState();
    
//     // Set status bar to transparent
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );

//     // Initialize animation controllers
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
    
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
    
//     _rotateController = AnimationController(
//       duration: const Duration(milliseconds: 3000),
//       vsync: this,
//     );

//     // Initialize animations
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     ));

//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.elasticOut,
//     ));

//     _rotateAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _rotateController,
//       curve: Curves.easeInOut,
//     ));

//     // Start animations
//     _startAnimations();
    
//     // Navigate to WelcomeScreen after delay
//     Timer(const Duration(seconds: 4), () {
//       Navigator.of(context).pushReplacement(
//         PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//           transitionDuration: const Duration(milliseconds: 800),
//         ),
//       );
//     });
//   }

//   void _startAnimations() {
//     _fadeController.forward();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _scaleController.forward();
//     });
//     Future.delayed(const Duration(milliseconds: 600), () {
//       _rotateController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _scaleController.dispose();
//     _rotateController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.center,
//             radius: 1.2,
//             colors: [
//               Color(0xFF8B5CF6), // Purple center
//               Color(0xFF06B6D4), // Cyan
//               Color(0xFF3B82F6), // Blue
//               Color(0xFF8B5CF6), // Purple
//             ],
//             stops: [0.0, 0.4, 0.7, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: AnimatedBuilder(
//             animation: Listenable.merge([_fadeAnimation, _scaleAnimation, _rotateAnimation]),
//             builder: (context, child) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Animated Logo Container
//                   Opacity(
//                     opacity: _fadeAnimation.value,
//                     child: Transform.scale(
//                       scale: _scaleAnimation.value,
//                       child: Transform.rotate(
//                         angle: _rotateAnimation.value * 0.1,
//                         child: Container(
//                           width: 280,
//                           height: 280,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(140),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.white.withOpacity(0.3),
//                                 blurRadius: 30,
//                                 spreadRadius: 10,
//                               ),
//                               BoxShadow(
//                                 color: Colors.purple.withOpacity(0.4),
//                                 blurRadius: 50,
//                                 spreadRadius: 5,
//                               ),
//                             ],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(140),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 gradient: RadialGradient(
//                                   colors: [
//                                     Colors.white.withOpacity(0.9),
//                                     Colors.white.withOpacity(0.7),
//                                   ],
//                                 ),
//                               ),
//                               padding: const EdgeInsets.all(20),
//                               child: Image.asset(
//                                 'assets/Images/logo.png',
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   // Fallback to icon if image not found
//                                   return const Icon(
//                                     Icons.recycling,
//                                     size: 120,
//                                     color: Color(0xFF8B5CF6),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
                  
//                   const SizedBox(height: 50),
                  
//                   // Animated Text
//                   Opacity(
//                     opacity: _fadeAnimation.value,
//                     child: Transform.translate(
//                       offset: Offset(0, 50 * (1 - _fadeAnimation.value)),
//                       child: Column(
//                         children: [
//                           ShaderMask(
//                             shaderCallback: (bounds) => const LinearGradient(
//                               colors: [
//                                 Colors.white,
//                                 Color(0xFFE0E7FF),
//                               ],
//                             ).createShader(bounds),
//                             child: const Text(
//                               'WasteNot',
//                               style: TextStyle(
//                                 fontSize: 48,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                                 letterSpacing: 2,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Turn waste into hope',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.white.withOpacity(0.9),
//                               fontWeight: FontWeight.w300,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             ' ',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white.withOpacity(0.8),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
                  
//                   const SizedBox(height: 80),
                  
//                   // Loading Indicator

//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // <-- generated by flutterfire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const WasteNotApp());
}

class WasteNotApp extends StatelessWidget {
  const WasteNotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WasteNot",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    // Transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    _startAnimations();

    // Navigate to WelcomeScreen after 4 seconds
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () => _scaleController.forward());
    Future.delayed(const Duration(milliseconds: 600), () => _rotateController.forward());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF8B5CF6),
              Color(0xFF06B6D4),
              Color(0xFF3B82F6),
              Color(0xFF8B5CF6),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([_fadeAnimation, _scaleAnimation, _rotateAnimation]),
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 0.1,
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(140),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 50,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(140),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.9),
                                    Colors.white.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/Images/logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.recycling,
                                    size: 120,
                                    color: Color(0xFF8B5CF6),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - _fadeAnimation.value)),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Color(0xFFE0E7FF)],
                            ).createShader(bounds),
                            child: const Text(
                              'WasteNot',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Turn waste into hope',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
