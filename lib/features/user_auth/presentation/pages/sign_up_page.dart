import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isSigningUp = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign Up", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "Email"),
              ),
              SizedBox(height: 10),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
              ),
              SizedBox(height: 10),

              // Phone Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(hintText: "Phone Number (e.g., +639123456789)"),
              ),
              SizedBox(height: 30),

              GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFF06D6A0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isSigningUp
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
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
      // Step 1: Create user with email/password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        print("User successfully created with email and password");

        // Step 2: Phone number verification (Send OTP)
        await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-resolved OTP, link phone number to the email account
            await user.linkWithCredential(credential);
            print("Phone number successfully linked.");
            // Proceed with your next steps, e.g., navigate to main page
            Navigator.pushNamed(context, "/main");
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone verification failed: ${e.message}")));
          },
          codeSent: (String verificationId, int? resendToken) {
            // OTP sent successfully, prompt user to enter the OTP
            _showOtpDialog(user, verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("Auto retrieval timeout: $verificationId");
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign Up Error: $e")));
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }

  void _showOtpDialog(User user, String verificationId) {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter OTP"),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter OTP sent to your phone"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String smsCode = otpController.text;

                // Create a PhoneAuthCredential with the entered OTP
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: smsCode,
                );

                // Link the phone number to the email/password user
                await user.linkWithCredential(credential);
                print("Phone number linked successfully");

                // Proceed with your next steps, e.g., navigate to main page
                Navigator.pushNamed(context, "/main");
              },
              child: Text("Verify"),
            ),
          ],
        );
      },
    );
  }
}
