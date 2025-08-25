import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonateClothesScreen extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  const DonateClothesScreen({
    super.key,
    required this.selectedIndex,
    required this.onNavTap,
  });

  @override
  State<DonateClothesScreen> createState() => _DonateClothesScreenState();
}

class _DonateClothesScreenState extends State<DonateClothesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _quantityController = TextEditingController();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedCategory = "Shirts, Blankets";
  String clothesName = "";
  String pickupLocation = "";
  String phoneNo = "";
  String additionalNotes = "";
  DateTime? pickupDate;
  TimeOfDay? pickupTime;

  // Google Maps location
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  bool _isGettingLocation = false;
  bool _isGettingMapAddress = false;
  String _fullAddress = "";
  String _mapAddress = "";
  GoogleMapController? _mapController;

  // Loading state for submission
  bool _isSubmitting = false;

  // User information
  User? _currentUser;
  String _userDisplayName = "Tejas2305";

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _quantityController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // Get current authenticated user
  void _getCurrentUser() {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      // Extract display name from email or use displayName
      String email = _currentUser!.email ?? "";
      String displayName = _currentUser!.displayName ?? "";
      
      if (displayName.isNotEmpty) {
        _userDisplayName = displayName;
      } else if (email.isNotEmpty) {
        // Extract name from email (part before @)
        _userDisplayName = email.split('@')[0];
      } else {
        _userDisplayName = "Tejas2305";
      }
    }
  }

  // Get current formatted timestamp
  String _getCurrentTimestamp() {
    DateTime now = DateTime.now().toUtc();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  // Firebase submission method
  Future<void> _submitToFirestore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please log in to submit donation"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      String userId = _currentUser!.uid;
      String userEmail = _currentUser!.email ?? "";
      String currentTimestamp = _getCurrentTimestamp();
      
      // Create donation data
      Map<String, dynamic> donationData = {
        'userId': userId,
        'userEmail': userEmail,
        'userDisplayName': _userDisplayName,
        'donationType': 'clothes',
        'clothesDetails': {
          'name': clothesName,
          'category': selectedCategory,
          'quantity': int.tryParse(_quantityController.text) ?? 0,
        },
        'pickupInformation': {
          'location': pickupLocation,
          'fullAddress': _fullAddress.isNotEmpty ? _fullAddress : pickupLocation,
          'coordinates': _selectedLocation != null ? {
            'latitude': _selectedLocation!.latitude,
            'longitude': _selectedLocation!.longitude,
          } : null,
          'pickupDate': pickupDate?.toIso8601String(),
          'pickupTime': pickupTime != null ? 
              '${pickupTime!.hour.toString().padLeft(2, '0')}:${pickupTime!.minute.toString().padLeft(2, '0')}' : null,
          'phoneNumber': phoneNo,
        },
        'additionalNotes': additionalNotes,
        'status': 'pending', // pending, confirmed, picked_up, completed, cancelled
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'submittedAt': DateTime.now().toUtc().toIso8601String(),
        'submissionTimestamp': '$currentTimestamp UTC',
      };

      // Add to Firestore
      DocumentReference docRef = await _firestore
          .collection('donations')
          .add(donationData);

      // Also add to user's donations subcollection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('donations')
          .doc(docRef.id)
          .set({
        'donationId': docRef.id,
        'donationType': 'clothes',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'clothesName': clothesName,
        'category': selectedCategory,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'submittedAt': DateTime.now().toUtc().toIso8601String(),
      });

      // Update user stats
      await _updateUserStats(userId);

      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      _showSuccessDialog(docRef.id, currentTimestamp);

    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      // Show error dialog
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _updateUserStats(String userId) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);
        
        if (!snapshot.exists) {
          // Create user document if it doesn't exist
          transaction.set(userDoc, {
            'email': _currentUser!.email,
            'displayName': _userDisplayName,
            'totalDonations': 1,
            'clothesDonations': 1,
            'foodDonations': 0,
            'booksDonations': 0,
            'totalItemsDonated': int.tryParse(_quantityController.text) ?? 0,
            'joinedAt': FieldValue.serverTimestamp(),
            'lastDonationAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Update existing user stats
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          int currentTotal = data['totalDonations'] ?? 0;
          int currentClothes = data['clothesDonations'] ?? 0;
          int currentItems = data['totalItemsDonated'] ?? 0;
          
          transaction.update(userDoc, {
            'totalDonations': currentTotal + 1,
            'clothesDonations': currentClothes + 1,
            'totalItemsDonated': currentItems + (int.tryParse(_quantityController.text) ?? 0),
            'lastDonationAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      print("Error updating user stats: $e");
    }
  }

  void _showSuccessDialog(String donationId, String timestamp) {
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
              const Text("Donation Submitted! 🎉"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Thank you, $_userDisplayName! 🙏", 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5C2C9C), fontSize: 16)),
                const SizedBox(height: 8),
                Text("Email: ${_currentUser?.email ?? 'N/A'}", 
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
                      Text("🆔 Donation ID:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
                      Text(donationId, style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: Colors.green[600])),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow("👕", "Clothes", clothesName),
                _buildDetailRow("📦", "Category", selectedCategory),
                _buildDetailRow("🔢", "Quantity", "${_quantityController.text} items"),
                const SizedBox(height: 8),
                Text("📍 Pickup Location:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 4),
                  child: Text(_fullAddress.isNotEmpty ? _fullAddress : pickupLocation,
                    style: const TextStyle(fontSize: 12)),
                ),
                if (_selectedLocation != null) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("Coordinates: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600], fontFamily: 'monospace')),
                  ),
                ],
                const SizedBox(height: 8),
                _buildDetailRow("📞", "Contact", phoneNo),
                if (pickupDate != null && pickupTime != null)
                  _buildDetailRow("📅", "Pickup", "${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year} at ${pickupTime!.format(context)}"),
                if (additionalNotes.isNotEmpty) 
                  _buildDetailRow("📝", "Notes", additionalNotes),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text("⏰ Submitted: $timestamp UTC", 
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                ),
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
                      Icon(Icons.cloud_done, color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Your donation has been securely saved to Firebase! We'll contact you soon for pickup.",
                          style: TextStyle(color: Colors.blue[700], fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reset form
                _resetForm();
              },
              child: const Text("OK", style: TextStyle(color: Color(0xFF5C2C9C), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red[600], size: 28),
              const SizedBox(width: 10),
              const Text("Submission Failed"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sorry, there was an error submitting your donation:"),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              const Text("Please try again later."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK", style: TextStyle(color: Colors.red[600])),
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    setState(() {
      clothesName = "";
      selectedCategory = "Shirts, Blankets";
      _quantityController.clear();
      pickupLocation = "";
      _locationController.clear();
      phoneNo = "";
      additionalNotes = "";
      pickupDate = null;
      pickupTime = null;
      _selectedLocation = null;
      _fullAddress = "";
    });
    _formKey.currentState?.reset();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        setState(() {
          _isGettingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDialog();
          setState(() {
            _isGettingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog();
        setState(() {
          _isGettingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });

      await _getAddressFromCoordinates(position.latitude, position.longitude);

    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _isGettingLocation = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error getting location: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _getAddressFromCoordinates(double latitude, double longitude, {bool isMapAddress = false}) async {
    if (isMapAddress) {
      setState(() {
        _isGettingMapAddress = true;
      });
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        List<String> addressParts = [];
        
        if (place.name != null && place.name!.isNotEmpty) {
          addressParts.add(place.name!);
        }
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
          addressParts.add(place.subAdministrativeArea!);
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          addressParts.add(place.postalCode!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        String address = addressParts.join(', ');
        
        setState(() {
          if (isMapAddress) {
            _mapAddress = address;
            _isGettingMapAddress = false;
          } else {
            _fullAddress = address;
            pickupLocation = address;
            _locationController.text = address;
            _isGettingLocation = false;
          }
        });

        print("Address: $address");
        print("Coordinates: $latitude, $longitude");
        
      } else {
        String coords = "${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}";
        setState(() {
          if (isMapAddress) {
            _mapAddress = coords;
            _isGettingMapAddress = false;
          } else {
            pickupLocation = coords;
            _locationController.text = coords;
            _isGettingLocation = false;
          }
        });
      }
    } catch (e) {
      print("Error getting address: $e");
      String coords = "${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}";
      setState(() {
        if (isMapAddress) {
          _mapAddress = coords;
          _isGettingMapAddress = false;
        } else {
          pickupLocation = coords;
          _locationController.text = coords;
          _isGettingLocation = false;
        }
      });
      
      if (mounted && !isMapAddress) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not get address, using coordinates instead"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showMapPicker() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: _MapSelectionScreen(
            currentLocation: _currentLocation,
            selectedLocation: _selectedLocation,
            onLocationSelected: (LatLng location) {
              setState(() {
                _selectedLocation = location;
              });
              _getAddressFromCoordinates(location.latitude, location.longitude);
              Navigator.pop(context);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("📍 Location selected successfully!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            onCurrentLocationPressed: () async {
              await _getCurrentLocation();
              if (_currentLocation != null) {
                setState(() {
                  _selectedLocation = _currentLocation;
                });
              }
            },
          ),
        );
      },
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.location_off, color: Colors.orange[600]),
              const SizedBox(width: 10),
              const Text('Location Services Disabled'),
            ],
          ),
          content: const Text(
            'Please enable location services in your device settings to use this feature.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: Text('Open Settings', style: TextStyle(color: Colors.blue[600])),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.location_disabled, color: Colors.red[600]),
              const SizedBox(width: 10),
              const Text('Location Permission Required'),
            ],
          ),
          content: const Text(
            'This app needs location permission to get your current location. Please grant permission in app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: Text('Open Settings', style: TextStyle(color: Colors.blue[600])),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBg = Color(0xFFEFDBF6);
    const Color boxColor = Color(0xFFB17CDF);
    const Color textColor = Color(0xFF5C2C9C);

    return Scaffold(
      backgroundColor: mainBg,
      appBar: AppBar(
        backgroundColor: mainBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            widget.onNavTap(0);
          },
        ),
        title: const Text(
          "Donate Clothes",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "👋 $_userDisplayName",
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _donateYourClothesBox(),
                const SizedBox(height: 20),
                _clothesCategoryBox(),
                const SizedBox(height: 20),
                sectionBox(
                  title: "Clothes Details",
                  child: Column(
                    children: [
                      inputField(
                        hint: "Clothes Name/Description",
                        icon: Icons.description,
                        onChanged: (val) => clothesName = val,
                        validator: (val) =>
                            val!.isEmpty ? "Enter clothes description" : null,
                      ),
                      inputField(
                        hint: "Quantity (number of items)",
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        controller: _quantityController,
                        onChanged: (val) {},
                        validator: (val) {
                          if (val!.isEmpty) return "Enter quantity";
                          if (int.tryParse(val) == null) return "Enter valid number";
                          if (int.parse(val) <= 0) return "Quantity must be greater than 0";
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                sectionBox(
                  title: "Pickup Information",
                  child: Column(
                    children: [
                      // Enhanced location input field
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _locationController,
                          enabled: !_isGettingLocation,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: _isGettingLocation 
                                ? "Getting your location..." 
                                : "Pickup Location",
                            prefixIcon: _isGettingLocation
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5C2C9C)),
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.location_on, color: Color(0xFF5C2C9C)),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.map, color: Colors.white),
                                onPressed: _showMapPicker,
                                tooltip: "Select on Map",
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFB17CDF)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFB17CDF)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF5C2C9C), width: 2),
                            ),
                            filled: true,
                            fillColor: _isGettingLocation ? Colors.grey[200] : Colors.grey[50],
                          ),
                          onChanged: (value) {
                            pickupLocation = value;
                          },
                          validator: (val) => val!.isEmpty ? "Enter pickup location" : null,
                        ),
                      ),
                      // Enhanced location buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isGettingLocation ? null : () async {
                                await _getCurrentLocation();
                                if (pickupLocation.isNotEmpty && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("📍 Current location updated!"),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              icon: _isGettingLocation 
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.my_location, color: Colors.white, size: 18),
                              label: Text(
                                _isGettingLocation ? "Getting..." : "Current Location", 
                                style: const TextStyle(color: Colors.white, fontSize: 12)
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: textColor,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _showMapPicker,
                              icon: const Icon(Icons.map, color: Colors.white, size: 18),
                              label: const Text(
                                "Select on Map", 
                                style: TextStyle(color: Colors.white, fontSize: 12)
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Enhanced coordinates info
                      if (_selectedLocation != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[50]!, Colors.blue[100]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue[200]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.blue[600], size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Selected Pickup Location",
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "📍 ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}",
                                style: TextStyle(
                                  color: Colors.blue[600],
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              if (_fullAddress.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "🏠 $_fullAddress",
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      dateTimePickerField(
                        hint: "Pickup Date and Time",
                        icon: Icons.schedule,
                        date: pickupDate,
                        time: pickupTime,
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            setState(() {
                              pickupDate = date;
                              pickupTime = time;
                            });
                          }
                        },
                      ),
                      inputField(
                        hint: "Phone No.",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => phoneNo = val,
                        validator: (val) =>
                            val!.isEmpty ? "Enter phone number" : null,
                      ),
                      inputField(
                        hint: "Additional Notes (Optional)",
                        icon: Icons.note_add,
                        onChanged: (val) => additionalNotes = val,
                        validator: (_) => null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [textColor, textColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    
