import 'package:flutter/material.dart';
import 'main_scaffold.dart'; // Import MainScaffold for navigation
import 'donor_signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // For form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Theme constants
  static const Color mainPurple = Color(0xFF5C2C9C);
  static const Color fieldPurple = Color(0xFFB17CDF);
  static const Color bgLight = Color(0xFFEFDBF6);
  static const Color gradientStrong = Color(0xFF9478B9);

  String? _errorText;

  void _handleLogin() {
    setState(() {
      _errorText = null;
    });
    // Hardcoded: test@example.com / password123
    if (_emailController.text.trim() == "test@example.com" &&
        _passwordController.text == "password123") {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScaffold()),
        (route) => false, // Remove all previous routes
      );
    } else {
      setState(() {
        _errorText = "Invalid email or password.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgLight, gradientStrong],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Welcome to WasteNot",
                    style: TextStyle(
                      color: mainPurple,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Together, we save and share",
                    style: TextStyle(
                      color: Color(0xFF9478B9),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: gradientStrong.withOpacity(0.14),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Let's Sign You In",
                          style: TextStyle(
                            color: mainPurple,
                            fontWeight: FontWeight.w700,
                            fontSize: 21,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Step in to make an impact today",
                          style: TextStyle(
                            color: Color(0xFF9478B9),
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Email Field
                        _ThemedTextField(
                          label: "Email Address",
                          hint: "Enter Your Email",
                          icon: Icons.alternate_email,
                          color: fieldPurple,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 13),

                        // Password Field
                        _ThemedTextField(
                          label: "Password",
                          hint: "Enter Your Password",
                          icon: Icons.lock_outline,
                          color: fieldPurple,
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: fieldPurple,
                            ),
                            onPressed: () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                          ),
                        ),
                        const SizedBox(height: 7),

                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: mainPurple,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              onChanged: (val) => setState(() => _rememberMe = val ?? false),
                            ),
                            const Text(
                              "Remember Me",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, minimumSize: Size(0, 0)),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: fieldPurple,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        if (_errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              _errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fieldPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _handleLogin,
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1.3,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("or sign in with", style: TextStyle(fontSize: 13)),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: Colors.white,
                              elevation: 0,
                            ),
                            onPressed: () {
                              // TODO: Google Sign In logic
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/google.png",
                                  height: 22,
                                  width: 22,
                                  errorBuilder: (ctx, err, stack) => const SizedBox(),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Continue with Google",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                                );
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  color: fieldPurple,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.8,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemedTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color color;
  final bool obscure;
  final Widget? suffix;
  final TextEditingController? controller;

  const _ThemedTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.color,
    this.obscure = false,
    this.suffix,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 2),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: color.withOpacity(0.7)),
            prefixIcon: Icon(icon, color: color),
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color, width: 1.4),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color, width: 2.0),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}