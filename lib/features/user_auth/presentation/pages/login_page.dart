import 'package:emeraldbank_mobileapp/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _verificationId = ''; // To store the verification ID for OTP verification

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              Image.asset(
                'lib/assets/pictures/emerald_logo_white.png',
                width: 100,
                height: 100,
                color: Color(0xFF06D6A0),
                colorBlendMode: BlendMode.srcIn,
              ),
              SizedBox(height: 4),
              Text(
                "EmeraldBank",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF044E42)),
              ),
              SizedBox(height: 80),
              Row(
                children: [
                  Text(
                    "Username/Email",
                    style: TextStyle(color: Color(0xFF1A1819), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              FormContainerWidget(controller: _emailController, isPasswordField: false),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(color: Color(0xFF1A1819), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              FormContainerWidget(controller: _passwordController, hintText: "", isPasswordField: true),
              SizedBox(height: 2),
              GestureDetector(
                onTap: () {
                  print("This is the forgot password");
                },
                child: Row(
                  children: [
                    Text(
                      "Forgot password?",
                      style: TextStyle(color: Color(0xFF044E42), fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _sigIn,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFF06D6A0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Version 1.4.3",
                style: TextStyle(color: Color(0xFF1A1819).withAlpha(128), fontSize: 10, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an Online Banking?",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xFF028A6E), fontSize: 12, fontWeight: FontWeight.bold),
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

  void _sigIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    // Attempt to sign in with email/password
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      print("User is successfully signed in");

      // After email/password login, trigger the OTP phone verification
      String phoneNumber = user.phoneNumber ?? ''; // Use the phone number from the user profile

      if (phoneNumber.isNotEmpty) {
        // Send OTP to the phone number
        _auth.verifyPhoneNumber(
          phoneNumber,
          (PhoneAuthCredential credential) {
            // On verification completion, sign the user in
            _auth.signInWithOTP(_verificationId, credential.smsCode!);
            Navigator.pushNamed(context, "/main");
          },
          (errorMessage) {
            print(errorMessage);
          },
          (verificationId) {
            // Store the verification ID to use it for OTP verification
            setState(() {
              _verificationId = verificationId;
            });
            // Prompt the user to enter OTP here
            _showOtpDialog();
          },
        );
      } else {
        print("Phone number not available for this user.");
      }
    } else {
      print("Some error happened");
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController otpController = TextEditingController();
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
                String otp = otpController.text;
                if (otp.isNotEmpty) {
                  // Verify the OTP
                  User? user = await _auth.signInWithOTP(_verificationId, otp);
                  if (user != null) {
                    Navigator.pushNamed(context, "/main");
                  } else {
                    print("OTP verification failed");
                  }
                }
              },
              child: Text("Verify"),
            ),
          ],
        );
      },
    );
  }
}