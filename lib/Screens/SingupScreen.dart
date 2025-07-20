import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_todo_list/Screens/HomeScreen.dart';
import 'package:smart_todo_list/Screens/LoginScreen.dart';
import 'package:smart_todo_list/Screens/phoneAuth.dart';
import 'package:smart_todo_list/widgets/uihelper.dart';

class SingupFormScreen extends StatefulWidget {
  const SingupFormScreen({super.key});

  @override
  State<SingupFormScreen> createState() => _SingupFormScreenState();
}

class _SingupFormScreenState extends State<SingupFormScreen> {
  final TextEditingController UserController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cnfpasswordController = TextEditingController();
  bool isPasswordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  signUp(String email, String password, String cnfpassword, String user) async {
    if (email.isEmpty || password.isEmpty || cnfpassword.isEmpty || user.isEmpty) {
      UiHelper.CustomAlertBox(context, "Please fill all fields.");
      return;
    }

    if (password != cnfpassword) {
      UiHelper.CustomAlertBox(context, "Passwords do not match!");
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    } on FirebaseAuthException catch (ex) {
      UiHelper.CustomAlertBox(context, ex.message ?? "Registration failed");
    }
  }


  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign in failed! ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5E7D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.015),
              const Text(
                "Hello ! Register to get,\nStarted",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              buildTextField(UserController, " Username"),
              SizedBox(height: screenHeight * 0.02),
              buildTextField(emailController, " Email"),
              SizedBox(height: screenHeight * 0.02),
              buildPasswordField(passwordController, " Password"),
              SizedBox(height: screenHeight * 0.02),
              buildPasswordField(cnfpasswordController, " Confirm Password"),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: () {
                  signUp(emailController.text.toString(), passwordController.text.toString(),cnfpasswordController.text.toString(), UserController.text.toString());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              const Center(
                child: Text(
                  "Or Register with",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: signInWithGoogle,
                    child: buildSocialIcon("assets/images/Google.png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      // phone auth logic
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneAuth()));
                    },
                    child: buildSocialIcon("assets/images/phoneCall.png"),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginFormScreen()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "Login Now",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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

  Widget buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildPasswordField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget buildSocialIcon(String assetName) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E7D0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(assetName, height: 50, width: 50),
    );
  }
}
