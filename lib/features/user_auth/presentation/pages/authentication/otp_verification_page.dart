import 'package:emeraldbank_mobileapp/utils/snackbar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final bool isSignUp;
  final String? accountNickName;
  final String? accountName;
  final String? accountNumber;
  final String? birthDate;
  final String? email;
  final String? phone;
  final String? password;
  // final PhoneAuthCredential? credential; // Optional for instant verification

 const OtpVerificationPage({
  super.key,
  required this.verificationId,
  this.isSignUp = false, // default to false
  this.accountName,
  this.accountNickName,
  this.accountNumber,
  this.birthDate,
  this.email,
  this.phone,
  this.password,
  // this.credential,
});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length != 6) return;

    setState(() => _isVerifying = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      if (widget.isSignUp) {
        // Manually verify OTP
        final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otp,
        );

        // ✅ Now create account
        UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: widget.email!, password: widget.password!);

        // ✅ Link phone to the new user
        await userCredential.user!.linkWithCredential(credential);

        // ✅ Add user to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': widget.email,
          'phoneNumber': widget.phone,
          'createdAt': Timestamp.now(),
          'balance': 10000,
          'accountName': widget.accountName,
          'accountNumber': widget.accountNumber,
          'accountNickname': widget.accountNickName,
          'birthDate': widget.birthDate,
          'issuedOn': "03/15/2024",
          'expiresEnd': "03/15/2034",
        });
      } else {
        // 🔐 Login flow: Sign in directly with phone OTP
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    if(!mounted) return;
    Navigator.pushReplacementNamed(context, "/main");
    } catch (e) {
      debugPrint("OTP verification error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 40),
                Row(
                  children: [
                    Text(
                    "One Time Password",
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF06D6A0),
                      fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                Text(
                    "We've sent a verification code to your mobile number via SMS. Enter the code below to complete two-factor authentication.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 53,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF06D6A0),
                              width: 1.5,
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF06D6A0),
                              width: 2,
                            )
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                          }
                          if (_controllers.every((controller) => controller.text.isNotEmpty)) {
                            _isVerifying ? null : _verifyOtp(); // Automatically verify when all fields are filled
                          }
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 30),
                Text("Didnt Receive Message?",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700
                ),),
                GestureDetector(
                  onTap: () {
                    showSnackbarMessage(context, "Resend Code Under Development");
                  },
                  child: Text("Resend Code",
                  style: TextStyle(
                    color: Color(0xFF028A6E),
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 30),
                // ElevatedButton(
                //   onPressed: _isVerifying ? null : _verifyOtp,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Color(0xFF06D6A0),
                //     minimumSize: Size(double.infinity, 45),
                //   ),
                //   child: _isVerifying
                //       ? CircularProgressIndicator(color: Colors.white)
                //       : Text("Verify OTP" , style: TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold)),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 48,
              ),
              child: Column(
                children: [
                  Text("Having a problem using OTP?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showSnackbarMessage(context, "Biometrics Under Development");
                    },
                    child: Text("Use Biometrics/Fingerprint",
                    style: TextStyle(
                      color: Color(0xFF028A6E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600
                    ),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
