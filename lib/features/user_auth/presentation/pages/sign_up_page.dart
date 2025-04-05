import 'package:emeraldbank_mobileapp/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/login_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  bool isSigningUp = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();   // Added phone number controller

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();   // Dispose phone controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign Up", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),

              // Username Field
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
              ),
              SizedBox(height: 10),

              // Email Field
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(height: 10),

              // Password Field
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(height: 10),

              // Phone Field
              FormContainerWidget(
                controller: _phoneController,
                hintText: "Phone Number (e.g., +639123456789)",   // With country code
                isPasswordField: false,
              ),
              SizedBox(height: 30),

              GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isSigningUp 
                      ? CircularProgressIndicator(color: Colors.white) 
                      : Text(
                          "Sign Up", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("Login", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Handles Sign Up and Links Phone with Email
  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String phone = _phoneController.text;

    // Validation for phone number format
    if (phone.isEmpty || !phone.startsWith('+')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid phone number with country code (e.g., +639123456789)")),
      );
      return;
    }

    setState(() {
      isSigningUp = true;
    });

    try {
      // Create email/password account
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        print("User successfully created with email and password");

        // --- Link phone number to email account ---
        PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
          verificationId: "dummy-id",      // Dummy ID for linking
          smsCode: "123456"                // Dummy SMS code
        );

        // Link the phone with the existing user
        await user.linkWithCredential(phoneCredential);
        print("Phone linked successfully!");

        // Navigate to main page
        Navigator.pushNamed(context, "/main");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error creating user")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up Error: $e")),
      );
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }
}
