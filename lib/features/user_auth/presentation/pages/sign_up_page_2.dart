import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/authentication/otp_verification_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage2 extends StatefulWidget {
  final String accountNickName;
  final String accountNumber;
  final String accountName;
  final String birthDate;
  final String email;
  final String phone;

  const SignUpPage2({
    super.key,
    required this.accountNickName,
    required this.accountNumber,
    required this.accountName,
    required this.birthDate,
    required this.email,
    required this.phone,
  });

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isSigningUp = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendOtpAndGoToOtpPage() async {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }
    else if (password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords must be the same. Try again.")),
      );
      return;
    }

    setState(() => isSigningUp = true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                verificationId: '',
                isSignUp: true,
                accountNickName: widget.accountNickName,
                accountNumber: widget.accountNumber,
                accountName: widget.accountName,
                birthDate: widget.birthDate,
                email: widget.email,
                phone: widget.phone,
                password: password,
              ),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Phone verification failed: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                verificationId: verificationId,
                isSignUp: true,
                accountNickName: widget.accountNickName,
                accountNumber: widget.accountNumber,
                accountName: widget.accountName,
                birthDate: widget.birthDate,
                email: widget.email,
                phone: widget.phone,
                password: password,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout: $verificationId");
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isSigningUp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Password", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "Create your password",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF06D6A0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "Password",
                  style: TextStyle(
                      color: Color(0xFF1A1819),
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Enter password",
              isPasswordField: true,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "Confirm Password",
                  style: TextStyle(
                      color: Color(0xFF1A1819),
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            FormContainerWidget(
              controller: _confirmPasswordController,
              hintText: "Enter password",
              isPasswordField: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: _sendOtpAndGoToOtpPage,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 36, left: 16, right: 16),
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
                  : Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
