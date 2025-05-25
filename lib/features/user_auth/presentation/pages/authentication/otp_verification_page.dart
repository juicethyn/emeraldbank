import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/main_navigation.dart';
import 'package:emeraldbank_mobileapp/utils/snackbar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final bool isSignUp;
  final String? accountNickName;
  final String? accountName;
  final String? accountNumber; // Should be Int
  final String? birthDate; 
  final String? email;
  final String? phone; // Int
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

  @override
  void initState() {
    super.initState();

    // Automatically send OTP when the page loads
    if (widget.phone != null) {
      _sendOtp(widget.phone!);
    } else {
      debugPrint("Phone number is null. Cannot send OTP.");
    }
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
      // Create a new user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: widget.email!, password: widget.password!);

      // Link phone number to the user
      await userCredential.user!.linkWithCredential(credential);

      // Add user details to Firestore
      final userDocRef = _firestore.collection('users').doc(userCredential.user!.uid);
      await userDocRef.set({
        'uid': userCredential.user!.uid,
        'accountNickname': widget.accountNickName,
        'email': widget.email,
        'phoneNumber': widget.phone,
        'createdAt': Timestamp.now(),
        'birthDate': widget.birthDate,
      });

      // Check if the account exists in the savings collection
      final querySnapshot = await _firestore
          .collection('savings')
          .where('savingsAccountInformation.accountNumber', isEqualTo: widget.accountNumber)
          .where('accountHolderName', isEqualTo: widget.accountName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the account exists, update the accountHolder field in the savings document
        final savingsDocRef = querySnapshot.docs.first.reference;
        await savingsDocRef.update({
          'accountHolder': userDocRef.path, // Set the Firestore reference to the user's document
        });

        // Link the savings account to the user's accountReferences subcollection
        final accountReferencesDocRef = userDocRef.collection('accountReferences').doc(userCredential.user!.uid);
        await accountReferencesDocRef.set({
          'creditCardAccounts': [], // Empty array
          'loanAccounst': [],        // Empty array
          'savingsAccounts': FieldValue.arrayUnion(["/" + savingsDocRef.path]), // Add the savings document path
        });

        debugPrint("Savings account successfully linked to the user.");
      } else {
        debugPrint("No matching savings account found.");
      }
    } else {
      // Sign in with the phone credential
      await FirebaseAuth.instance.signInWithCredential(credential);
    }

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainNavigation()),
      (route) => false, // Remove all previous routes
    );
  } catch (e) {
    debugPrint("OTP verification error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid OTP. Please try again.")),
    );
  } finally {
    setState(() => _isVerifying = false);
  }
}

  void _sendOtp(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, "/main");
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("Verification failed: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed. Please try again.")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          verificationId = verificationId; // Save the verification ID
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP sent to $phoneNumber")),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          verificationId = verificationId; // Save the verification ID
        });
      },
    );
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
                // Wrap the Row in a SingleChildScrollView for horizontal scrolling
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 44, // Reduced width for better fit
                        margin: EdgeInsets.symmetric(horizontal: 4),
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
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                            }
                            if (_controllers.every((controller) => controller.text.isNotEmpty)) {
                              _isVerifying ? null : _verifyOtp();
                            }
                          },
                        ),
                      );
                    }),
                  ),
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