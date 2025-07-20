import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_todo_list/widgets/uihelper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  forgotpass(String email) async {
    if (email.isEmpty) {
      UiHelper.CustomAlertBox(context, "Please enter your email.");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent!")),
      );
      Navigator.pop(context); // Optionally navigate back after success
    } on FirebaseAuthException catch (e) {
      UiHelper.CustomAlertBox(context, e.message ?? "Something went wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5E7D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Image
              Center(
                child: Image.asset(
                  'assets/images/forget.png',
                  height: screenHeight * 0.28,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Heading
              Center(
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Description
              Center(
                child: Text(
                  "Please enter your email address.\nYou will receive a link to create a new password via email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenHeight * 0.018,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.035),

              // Email Input
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    forgotpass(emailController.text.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE76430),
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Send",
                    style: TextStyle(
                      fontSize: screenHeight * 0.022,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
