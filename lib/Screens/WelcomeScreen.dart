import 'package:flutter/material.dart';
import 'package:smart_todo_list/Screens/LoginScreen.dart';
import 'SingupScreen.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5E7D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Smart Todo-List",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),
              // Responsive image with constraints
              Container(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.4,
                  maxWidth: screenWidth * 0.85,
                ),
                child: Image.asset(
                  "assets/images/welcome.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              const Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to your account to continue",
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SingupFormScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginFormScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    ),
                    child: const Text(
                      "Log in",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
