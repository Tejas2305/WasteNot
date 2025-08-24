import 'package:flutter/material.dart';

class DonateBooksScreen extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  const DonateBooksScreen({
    super.key,
    required this.selectedIndex,
    required this.onNavTap,
  });

  @override
  State<DonateBooksScreen> createState() => _DonateBooksScreenState();
}

class _DonateBooksScreenState extends State<DonateBooksScreen> {
  final _formKey = GlobalKey<FormState>();

  String selectedCategory = "Novels and Stories";
  String selectedQuantity = "1";
  String bookName = "";
  String pickupLocation = "";
  String phoneNo = "";
  String additionalNotes = "";
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
            widget.onNavTap(0);
          },
        ),
        title: const Text(
          "Donate Books",
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
                _shareYourBooksBox(),
                const SizedBox(height: 20),
                _bookCategoryBox(),
                const SizedBox(height: 20),
                sectionBox(
                  title: "Book Details",
                  child: Column(
                    children: [
                      inputField(
                        hint: "Book Name",
                        iconPath: "assets/Images/book.png",
                        onChanged: (val) => bookName = val,
                        validator: (val) =>
                            val!.isEmpty ? "Enter book name" : null,
                      ),
                      dropdownField(
                        hint: "Quantity",
                        iconPath: "assets/Images/quantity.png",
                        value: selectedQuantity,
                        items: ["1", "2", "3", "4", "5", "More than 5"],
                        onChanged: (value) {
                          setState(() {
                            selectedQuantity = value!;
                          });
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

  Widget _shareYourBooksBox() {
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
                  "Share Your Books",
                  style: TextStyle(
                    color: Color(0xFF5C2C9C),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Turn old books into new opportunities for others..",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Image.asset("assets/Images/books.png", height: 50),
        ],
      ),
    );
  }

  Widget _bookCategoryBox() {
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
            "Book Category",
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
                hintText: "Select Book Category",
                hintStyle: const TextStyle(color: Color(0xFF5C2C9C)),
              ),
              value: selectedCategory,
              items: [
                "Novels and Stories",
                "Textbooks",
                "Children's Books",
                "Reference Books",
                "Other"
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