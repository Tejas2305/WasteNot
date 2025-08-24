import 'package:flutter/material.dart';

class NGOLoginPage extends StatelessWidget {
  const NGOLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // For responsive width (mobile/web)
    final double width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 400;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380, maxHeight: 700),
          margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3674B5), // #3674B5
                Color(0xFFA1E3F9), // #A1E3F9
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 14 : 30,
                vertical: isNarrow ? 24 : 48,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Welcome
                  const Text(
                    "Welcome to WasteNot",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Together, we save and share",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFECF7FF),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000), // black with 20% opacity
                          blurRadius: 24,
                          spreadRadius: 3,
                          offset: Offset(0, 12),
                        ),
                        BoxShadow(
                          color: Color(0x118BB7D6), // blue tint for ambient shadow
                          blurRadius: 40,
                          spreadRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Login as NGO
                        const Text(
                          "Login as NGO",
                          style: TextStyle(
                            color: Color(0xFF3674B5),
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Access your account to keep spreading hope\nand kindness.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8BB7D6),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email Field
                        _LoginTextField(
                          label: "Email Address",
                          hint: "Enter Your Email",
                          icon: Icons.email_outlined,
                          obscure: false,
                        ),
                        const SizedBox(height: 18),

                        // Password Field
                        _LoginTextField(
                          label: "Password",
                          hint: "Enter Your Password",
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                        const SizedBox(height: 26),

                        // Log In Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3674B5),
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shadowColor: Colors.black45,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;

  const _LoginTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3674B5),
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7FBFF),
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A3674B5), // blue with 10% opacity
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Color(0xFFBCE0FB),
              width: 1.1,
            ),
          ),
          child: TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFB1BFD5), fontSize: 14),
              prefixIcon: Icon(icon, color: Color(0xFF3674B5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              suffixIcon: obscure
                  ? Icon(Icons.visibility_off_outlined, color: Color(0xFFB1BFD5))
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}