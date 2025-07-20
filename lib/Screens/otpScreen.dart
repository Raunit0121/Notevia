import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_todo_list/Screens/HomeScreen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationid;
  final String phoneNumber;

  const OtpScreen({super.key, required this.verificationid, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5E7D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07, vertical: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),

              const Text(
                "Enter the\nOTP code",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Show dynamic phone number here
              Text(
                "We have sent a 6-digit code\nto ${widget.phoneNumber}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {
                  otpCode = value;
                },
                pinTheme: PinTheme(
                  activeColor: Colors.black,
                  selectedColor: Colors.black,
                  inactiveColor: Colors.black54,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 55,
                  fieldWidth: 50,
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: screenHeight * 0.03),

              GestureDetector(
                onTap: () {
                  // TODO: Add resend OTP functionality
                },
                child: const Text(
                  "Resend",
                  style: TextStyle(
                    color: Color(0xFFE76430),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (otpCode.isEmpty || otpCode.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter a valid 6-digit OTP.")),
                      );
                      return;
                    }

                    try {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationid,
                        smsCode: otpCode,
                      );

                      await FirebaseAuth.instance.signInWithCredential(credential);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Homescreen()),
                      );
                    } catch (ex) {
                      log(ex.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid OTP. Please try again.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE76430),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              Image.asset(
                'assets/images/phone_otp.png',
                height: screenHeight * 0.15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
