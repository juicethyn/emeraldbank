// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // IN NEED OF REVISION

// class PhoneVerificationPage extends StatefulWidget {
//   final User user;

//   const PhoneVerificationPage({super.key, required this.user});

//   @override
//   State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
// }

// class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _otpController = TextEditingController();

//   String _verificationId = "";
//   bool _isSendingOTP = false;
//   bool _isVerifying = false;

//   @override
//   void initState() {
//     super.initState();
//     _sendOTP();  // Automatically send OTP on page load
//   }

//   /// ✅ Send OTP using Firebase production servers
//   Future<void> _sendOTP() async {
//     setState(() => _isSendingOTP = true);

//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: '+1 123-456-7890',  // Android Emulator's default number
//         timeout: const Duration(seconds: 60),  // OTP expiration time
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // ✅ Auto-verification for certain devices
//           await widget.user.linkWithCredential(credential);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Phone verified successfully!")),
//           );
//           Navigator.pushReplacementNamed(context, "/main");
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Verification failed: ${e.message}")),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           _verificationId = verificationId;
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("OTP sent successfully")),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId;
//         },
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send OTP: $e")),
//       );
//     } finally {
//       setState(() => _isSendingOTP = false);
//     }
//   }

//   /// ✅ Verify the OTP entered by the user
//   Future<void> _verifyOTP() async {
//     setState(() => _isVerifying = true);

//     try {
//       // ✅ Create phone credential with Firebase production verification ID
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId,
//         smsCode: _otpController.text,
//       );

//       await widget.user.linkWithCredential(credential);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Phone number verified successfully!")),
//       );

//       Navigator.pushReplacementNamed(context, "/main");
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid OTP: $e")),
//       );
//     } finally {
//       setState(() => _isVerifying = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Phone Verification")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "OTP sent to +1 555-123-4567",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
            
//             TextField(
//               controller: _otpController,
//               decoration: InputDecoration(
//                 labelText: "Enter OTP",
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _isVerifying ? null : _verifyOTP,
//               child: _isVerifying 
//                 ? CircularProgressIndicator()
//                 : Text("Verify OTP"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
