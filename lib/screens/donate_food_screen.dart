import 'package:flutter/material.dart';

class DonateFoodScreen extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  const DonateFoodScreen({
    super.key,
    required this.selectedIndex,
    required this.onNavTap,
  });

  @override
  State<DonateFoodScreen> createState() => _DonateFoodScreenState();
}

class _DonateFoodScreenState extends State<DonateFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  String selectedCategory = "Cooked Food";
  String selectedQuantity = "250g";
  String foodName = "";
  String pickupLocation = "";
  String phoneNo = "";
  String additionalNotes = "";
  DateTime? expiryDate;
  DateTime? pickupDate;
  TimeOfDay? pickupTime;

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
            // Go to Home tab in main page
            widget.onNavTap(0);
          },
        ),
        title: const Text(
          "Donate Food",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                _shareYourFoodBox(),
                const SizedBox(height: 20),
                _foodCategoryBox(),
                const SizedBox(height: 20),
                sectionBox(
                  title: "Food Details",
                  child: Column(
                    children: [
                      inputField(
                        hint: "Food Name",
                        iconPath: "assets/Images/food.png",
                        onChanged: (val) => foodName = val,
                        validator: (val) =>
                            val!.isEmpty ? "Enter food name" : null,
                      ),
                      dropdownField(
                        hint: "Quantity",
                        iconPath: "assets/Images/quantity.png",
                        value: selectedQuantity,
                        items: [
                          "250g",
                          "500g",
                          "750g",
                          "1kg",
                          "More than 1kg",
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedQuantity = value!;
                          });
                        },
                      ),
                      datePickerField(
                        hint: "Expiry Date",
                        iconPath: "assets/Images/calendar.png",
                        date: expiryDate,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              expiryDate = picked;
                            });
                          }
                        },
                      ),
                      inputField(
                        hint: "Upload Image",
                        iconPath: "assets/Images/upload.png",
                        enabled: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                sectionBox(
                  title: "Pickup Information",
                  child: Column(
                    children: [
                      inputField(
                        hint: "Pickup Location",
                        iconPath: "assets/Images/location.png",
                        onChanged: (val) => pickupLocation = val,
                        validator: (val) =>
                            val!.isEmpty ? "Enter location" : null,
                      ),
                      dateTimePickerField(
                        hint: "Pickup Date and Time",
                        iconPath: "assets/Images/calendar.png",
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
                        iconPath: "assets/Images/phone.png",
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => phoneNo = val,
                        validator: (val) =>
                            val!.isEmpty ? "Enter phone number" : null,
                      ),
                      inputField(
                        hint: "Additional Notes (Optional)",
                        iconPath: "assets/Images/notes.png",
                        onChanged: (val) => additionalNotes = val,
                        validator: (_) => null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Donation submitted!")),
                      );
                    }
                  },
                  child: const Text(
                    "Donate Now",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // REMOVE inner bottomNavigationBar!
    );
  }

  Widget _shareYourFoodBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB17CDF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Share Your Food",
                  style: TextStyle(
                    color: Color(0xFF5C2C9C),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Share your meal, spread love,\nand make a difference one plate at a time.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Image.asset("assets/Images/food.png", height: 50),
        ],
      ),
    );
  }

  Widget _foodCategoryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB17CDF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Food Category",
            style: TextStyle(
              color: Color(0xFF5C2C9C),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: "Select Food Category",
                hintStyle: const TextStyle(color: Color(0xFF5C2C9C)),
              ),
              value: selectedCategory,
              items: [
                "Cooked Food",
                "Raw Food",
                "Packed Food",
                "Beverages"
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a category' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionBox({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB17CDF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF5C2C9C),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget inputField({
    required String hint,
    required String iconPath,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, height: 24, width: 24),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              enabled: enabled,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFF5C2C9C)),
                border: InputBorder.none,
              ),
              onChanged: onChanged,
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Widget dropdownField({
    required String hint,
    required String iconPath,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, height: 24, width: 24),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: const InputDecoration(border: InputBorder.none),
              items: items
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget datePickerField({
    required String hint,
    required String iconPath,
    DateTime? date,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, height: 24, width: 24),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  date != null
                      ? "${date.day}/${date.month}/${date.year}"
                      : hint,
                  style: const TextStyle(color: Color(0xFF5C2C9C)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dateTimePickerField({
    required String hint,
    required String iconPath,
    DateTime? date,
    TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, height: 24, width: 24),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  date != null && time != null
                      ? "${date.day}/${date.month}/${date.year} ${time.format(context)}"
                      : hint,
                  style: const TextStyle(color: Color(0xFF5C2C9C)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}